require 'csv'
require_relative 'invoice'

class InvoiceRepository

  attr_reader :all

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
    @all ||= content.map { |row| Invoice.new(row.to_h) }
  end

  def find_by_id(id)
    all.detect { |invoice| invoice.id == id }
  end

  def find_all_by_customer_id(customer_id)
    all.select { |invoice| invoice.customer_id == customer_id }
  end

  def find_all_by_merchant_id(merchant_id)
    all.select { |invoice| invoice.merchant_id == merchant_id }
  end

  def find_all_by_status(status)
    all.select { |invoice| invoice.status == status.to_sym }
  end

  def find_all_by_date_created(date)
     all.select { |invoice| invoice.created_at == Time.parse(date) }
   end

  def invoices_each_day
    @invoices_each_day ||= all.group_by do |invoice|
      invoice.created_at.strftime("%A")
     end
  end
 end
