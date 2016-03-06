module Banking
  class Transfer
    attr_reader :source_account, :destination_account, :amount

    def initialize(source_account, destination_account, amount)
      @source_account = source_account
      @destination_account = destination_account
      @amount = amount
    end
  end
end
