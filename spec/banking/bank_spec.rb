require 'spec_helper'

describe Banking::Bank do
  it 'should can add accounts' do
    bank = described_class.new
    account = Banking::Account.new
    bank.add_account(account)

    expect(bank.accounts).to include account
  end

  it 'should fail when neither of the two accounts are on accounts bank' do
    bank = described_class.new
    transfer = Banking::Transfer.new(Banking::Account.new, Banking::Account.new, 100)

    expect do
      bank.execute_transfer(transfer)
    end.to raise_error described_class::NotValidTransferException
  end

  it 'should keep a list of all transfers' do
    stub_const("#{described_class}::INTER_BANK_CHANCE_OF_FAILURE", 0)

    transfer_one = Banking::Transfer.new(Banking::Account.new, Banking::Account.new, 1000)
    transfer_two = Banking::Transfer.new(Banking::Account.new, Banking::Account.new, 109)

    bank = described_class.new

    bank.add_account(transfer_one.source_account)
    bank.add_account(transfer_two.source_account)

    bank.execute_transfer(transfer_one)
    bank.execute_transfer(transfer_two)

    expect(bank.transfers_history).to eq [transfer_one, transfer_two]
  end

  context 'Intra-bank transfers' do
    it 'should execute intra-bank transfers' do
      source_account_initial_balance = 100
      source_account = Banking::Account.new(source_account_initial_balance)

      destination_account_initial_balance = 1039.80
      destination_account = Banking::Account.new(destination_account_initial_balance)

      bank = described_class.new
      bank.add_account(source_account)
      bank.add_account(destination_account)

      transfer_amount = 123.40
      transfer = Banking::Transfer.new(source_account, destination_account, transfer_amount)

      bank.execute_transfer(transfer)

      expect(source_account.balance).to eq source_account_initial_balance - transfer_amount
      expect(destination_account.balance).to eq destination_account_initial_balance + transfer_amount
    end
  end

  context 'Inter-bank transfers' do
    it 'should fail when the chance of failure is 100%' do
      stub_const("#{described_class}::INTER_BANK_CHANCE_OF_FAILURE", 100)

      source_account = Banking::Account.new
      destination_account = Banking::Account.new

      bank = described_class.new
      bank.add_account(source_account)

      transfer_amount = described_class::INTER_BANK_TRANSFER_LIMIT
      transfer = Banking::Transfer.new(source_account, destination_account, transfer_amount)

      expect do
        bank.execute_transfer(transfer)
      end.to raise_error described_class::InterBankTranferException
    end

    it 'should not execute transfers with amount greater than limit' do
      stub_const("#{described_class}::INTER_BANK_CHANCE_OF_FAILURE", 0)

      source_account = Banking::Account.new
      destination_account = Banking::Account.new

      bank = described_class.new
      bank.add_account(source_account)

      transfer_amount = described_class::INTER_BANK_TRANSFER_LIMIT + 1.0
      transfer = Banking::Transfer.new(source_account, destination_account, transfer_amount)

      expect do
        bank.execute_transfer(transfer)
      end.to raise_error described_class::InterBankLimitException
    end

    it 'should execute inter-bank transfers' do
      stub_const("#{described_class}::INTER_BANK_CHANCE_OF_FAILURE", 0)

      source_account_initial_balance = 230.0
      source_account = Banking::Account.new(source_account_initial_balance)

      destination_account_initial_balance = 1060.0
      destination_account = Banking::Account.new(destination_account_initial_balance)

      bank = described_class.new
      bank.add_account(source_account)

      transfer_amount = described_class::INTER_BANK_TRANSFER_LIMIT
      transfer = Banking::Transfer.new(source_account, destination_account, transfer_amount)
      commission = described_class::INTER_BANK_TRANSFER_COMMISSION

      bank.execute_transfer(transfer)

      expect(source_account.balance).to eq source_account_initial_balance - transfer_amount - commission
      expect(destination_account.balance).to eq destination_account_initial_balance + transfer_amount
    end
  end
end
