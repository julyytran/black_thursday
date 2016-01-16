require 'csv'
require_relative 'invoice'


class InvoiceRepository
  attr_reader :all

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file_path = nil)
    content ||= CSV.open "#{file_path}", headers: true, header_converters: :symbol
    @all = content.map { |row| Invoice.new(row.to_h) }
  end

  def find_by_id(id)
    all.detect do |invoice|
      invoice.id == id
    end
  end.to_i

  def find_all_by_customer_id(customer_id)
    all.select do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    all.select do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    all.select do |invoice|
      invoice.status == status
    end
  end
end
