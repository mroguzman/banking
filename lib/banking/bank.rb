module Banking
  class Bank
    INTER_BANK_TRANSFER_COMMISSION = 5.0
    INTER_BANK_TRANSFER_LIMIT = 1000.0
    INTER_BANK_CHANCE_OF_FAILURE = 30

    class InterBankLimitException < StandardError; end
    class InterBankTranferException < StandardError; end
    class NotValidTransferException < StandardError; end

    attr_reader :accounts, :transfers_history

    def initialize
      @accounts = []
      @transfers_history = []
    end

    def execute_transfer(transfer)
      if intra_bank_transfer? transfer
        transfer.execute
      elsif inter_bank_transfer? transfer
        raise InterBankLimitException if transfer.amount > INTER_BANK_TRANSFER_LIMIT
        raise InterBankTranferException if rand(1..100) <= INTER_BANK_CHANCE_OF_FAILURE

        transfer.execute(commission: INTER_BANK_TRANSFER_COMMISSION)
      else
        raise NotValidTransferException
      end
      
      add_transfer_to_history(transfer)
    end

    def add_account(account)
      @accounts << account
    end

    private

    def add_transfer_to_history(transfer)
      @transfers_history << transfer
    end

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
