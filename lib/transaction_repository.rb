require 'csv'
require_relative 'transaction'

class TransactionRepository
  attr_reader :all

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end

  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
    @all ||= content.map { |row| Transaction.new(row.to_h) }
  end

  def find_by_id(id)
    all.detect { |transaction| transaction.id == id }
  end

  def find_all_by_invoice_id(invoice_id)
    all.select { |transaction| transaction.invoice_id == invoice_id }
  end

  def find_all_by_credit_card_number(ccn)
    all.select { |transaction| transaction.credit_card_number == ccn }
  end

  def find_all_by_result(result)
    all.select { |transaction| transaction.result == result}
  end

  def successful_transactions
    all.select { |transaction| transaction.result == "success"}
  end

  def failed_transactions
    all.select { |transaction| transaction.result == "failed"}
  end
end
