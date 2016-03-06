module Banking
  class Account
    attr_reader :balance

    def initialize(balance = 0.0)
      @balance = balance
    end

    def execute_transaction(amount)
      @balance += amount
    end
  end
end
