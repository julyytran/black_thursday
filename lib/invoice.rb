require "time"
require_relative 'sales_engine'
require_relative 'invoice_item_repository'

class Invoice
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data[:id].to_s.to_i
  end

  def customer_id
    data[:customer_id].to_s.to_i
  end

  def merchant_id
    data[:merchant_id].to_s.to_i
  end

  def status
    data[:status]
  end

  def created_at
    Time.parse(data[:created_at])
  end

  def updated_at
    Time.parse(data[:updated_at])
  end

  def merchant
    merchants = SalesEngine.merchants
    merchants.find_by_id(merchant_id)
  end

  def items
    invoices = SalesEngine.invoice_items
    invoices.find_all_by_invoice_id(id)
  end

  def transactions
    transactions = SalesEngine.transactions
    transactions.find_all_by_invoice_id(id)
  end

  def customer
    customer = SalesEngine.customers
    customer.find_by_id(customer_id)
end
