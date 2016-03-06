require 'spec_helper'

describe Banking::Transfer do
  it 'should have a source account' do
    source_account = Banking::Account.new
    transfer = described_class.new(source_account, Banking::Account.new, 100)

    expect(transfer.source_account).to eq source_account
  end

  it 'should have a destination account' do
    destination_account = Banking::Account.new
    transfer = described_class.new(Banking::Account.new, destination_account, 100)

    expect(transfer.destination_account).to eq destination_account
  end

  it 'should have an amount' do
    amount = 100
    transfer = described_class.new(Banking::Account.new, Banking::Account.new, amount)

    expect(transfer.amount).to eq amount
  end

  it 'should execute the transfer' do
    source_account_initial_balance = 32.0
    source_account = Banking::Account.new(source_account_initial_balance)

    destination_account_initial_balance = 42.0
    destination_account = Banking::Account.new(destination_account_initial_balance)

    transfer_amount = 120.32
    transfer = described_class.new(source_account, destination_account, transfer_amount)

    commission = 12.20
    transfer.execute(commission: commission)

    expect(transfer.source_account.balance).to eq(
      source_account_initial_balance -
      transfer_amount -
      commission
    )

    expect(transfer.destination_account.balance).to eq(
      destination_account_initial_balance + transfer_amount
    )
  end
end
