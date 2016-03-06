module Banking
  class Bank
    INTER_BANK_TRANSFER_COMMISSION = 5.0
    INTER_BANK_TRANSFER_LIMIT = 1000.0
    INTER_BANK_CHANCE_OF_FAILURE = 30

    class InterBankLimitException < StandardError; end
    class InterBankTranferException < StandardError; end
    class NotValidTransferException < StandardError; end

    attr_reader :accounts

    def initialize
      @accounts = []
    end

    def execute_transfer(transfer)
      if intra_bank_transfer? transfer
        transfer.source_account.execute_transaction(-transfer.amount)
        transfer.destination_account.execute_transaction(transfer.amount)
      elsif inter_bank_transfer? transfer
        raise InterBankLimitException if transfer.amount > INTER_BANK_TRANSFER_LIMIT
        raise InterBankTranferException if rand(1..100) <= INTER_BANK_CHANCE_OF_FAILURE

        transfer.source_account.execute_transaction(-transfer.amount)
        transfer.source_account.execute_transaction(-INTER_BANK_TRANSFER_COMMISSION)
        transfer.destination_account.execute_transaction(transfer.amount)
      else
        raise NotValidTransferException
      end
    end

    def add_account(account)
      @accounts << account
    end

    private

    def intra_bank_transfer?(transfer)
      @accounts.include?(transfer.source_account) &&
      @accounts.include?(transfer.destination_account)
    end

    def inter_bank_transfer?(transfer)
      @accounts.include?(transfer.source_account) &&
      !@accounts.include?(transfer.destination_account)
    end
  end
end
