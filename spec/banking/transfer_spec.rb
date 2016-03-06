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
end
