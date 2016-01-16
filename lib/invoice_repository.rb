require 'csv'
require_relative 'invoice'

class InvoiceRepository

  attr_reader :all

<<<<<<< HEAD
  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file_path = nil)
    content ||= CSV.open "#{file_path}", headers: true, header_converters: :symbol
=======
  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
>>>>>>> f45f471f5439a84f0bb0a04b3148b5e8bb35dee6
    @all = content.map { |row| Invoice.new(row.to_h) }
  end

  def find_by_id(id)
<<<<<<< HEAD
    all.detect do |invoice|
      invoice.id == id
    end
  end.to_i
=======
    all.detect { |invoice| invoice.id == id }
  end
>>>>>>> f45f471f5439a84f0bb0a04b3148b5e8bb35dee6

  def find_all_by_customer_id(customer_id)
    all.select { |invoice| invoice.customer_id == customer_id }
  end

  def find_all_by_merchant_id(merchant_id)
    all.select { |invoice| invoice.merchant_id == merchant_id }
  end

  def find_all_by_status(status)
    all.select { |invoice| invoice.status == status }
  end

end
