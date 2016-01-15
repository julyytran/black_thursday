require 'csv'
require_relative 'invoice'


class InvoiceRepository
  attr_reader :all

  def initialize(data)
    content = CSV.open "#{data}", headers: true, header_converters: :symbol
    @all = content.map { |row| Invoice.new(row.to_h) }
  end

  def find_by_id(id)
    all.detect do |invoice|
      invoice.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    all.select do |invoice|
    end
    # returns either [] or one or more matches which have a matching customer ID

  end

  def find_all_by_merchant_id
    # returns either [] or one or more matches which have a matching merchant ID

  end

  def find_all_by_status
    # returns either [] or one or more matches which have a matching status

  end
end
