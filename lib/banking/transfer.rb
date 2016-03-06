module Banking
  class Transfer
    attr_reader :source_account, :destination_account, :amount

    def initialize(source_account, destination_account, amount)
      @source_account = source_account
      @destination_account = destination_account
      @amount = amount
    end

    def execute(commission: 0.0)
      source_account.execute_transaction(-amount)
      source_account.execute_transaction(-commission)
      destination_account.execute_transaction(amount)
    end
  end
end
