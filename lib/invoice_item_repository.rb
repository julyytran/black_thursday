require 'csv'
require_relative '../lib/invoice_item'

class InvoiceItemRepository
  attr_reader :all

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
    @all ||= content.map { |row| InvoiceItem.new(row.to_h) }
  end

  def find_by_id(id)
    all.detect { |data| data.id == id }
  end

  def find_all_by_item_id(item_id)
    all.select { |data| data.item_id == item_id }
  end

  def find_all_by_invoice_id(invoice_id)
    all.select { |data| data.invoice_id == invoice_id }
  end
end
