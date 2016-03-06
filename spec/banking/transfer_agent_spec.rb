require 'spec_helper'

describe Banking::TransferAgent do
  context 'Inter-bank transfers' do
    it 'should ensure that the transfer is done' do
      source_account_initial_balance = 30_000
      source_account = Banking::Account.new(source_account_initial_balance)
      source_bank = Banking::Bank.new
      source_bank.add_account(source_account)

      destination_account_initial_balance = 23_000
      destination_account = Banking::Account.new(destination_account_initial_balance)

      transfer_amount = 20_001
      transfer = Banking::Transfer.new(source_account, destination_account, transfer_amount)

      transfer_agent = described_class.new(source_bank, transfer)
      transfer_agent.execute_transfer

      commission = Banking::Bank::INTER_BANK_TRANSFER_COMMISSION
      limit = Banking::Bank::INTER_BANK_TRANSFER_LIMIT
      total_commission = (transfer_amount / limit.to_f).ceil * commission

      expect(source_account.balance).to eq source_account_initial_balance - transfer_amount - total_commission
      expect(destination_account.balance).to eq destination_account_initial_balance + transfer_amount
    end
  end
end
