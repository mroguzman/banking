require 'spec_helper'

describe Banking::Account do
  it 'should receive money' do
    account = described_class.new

    expect do
      account.execute_transaction(500)
    end.to change { account.balance }.from(0.0).to(500)
  end

  it 'should send money' do
    account = described_class.new(12.30)

    expect do
      account.execute_transaction(-100)
    end.to change { account.balance }.from(12.30).to(-87.7)
  end
end
