module Banking
  class TransferAgent
    def initialize(source_bank, transfer)
      @source_bank = source_bank
      @transfer = transfer
    end

    def execute_transfer
      transfer_amounts.each do |amount|
        split_transfer = Banking::Transfer.new(
          transfer.source_account,
          transfer.destination_account,
          amount
        )

        safe_execute_transfer(split_transfer)
      end
    end

    private

    attr_reader :source_bank, :transfer

    def safe_execute_transfer(transfer)
      source_bank.execute_transfer(transfer)
    rescue Banking::Bank::InterBankTranferException
      retry
    end

    def transfer_amounts
      limit = Banking::Bank::INTER_BANK_TRANSFER_LIMIT
      amount_rest = transfer.amount % limit

      transfer_amounts = Array.new((transfer.amount / limit).floor, limit)
      transfer_amounts << amount_rest if amount_rest > 0

      transfer_amounts
    end
  end
end
