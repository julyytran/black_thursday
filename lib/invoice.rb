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
    invoice_items = SalesEngine.invoice_items
    invoice_items.find_all_by_invoice_id(id)
  end

  def transactions
    transactions = SalesEngine.transactions
    transactions.find_all_by_invoice_id(id)
  end

  def customer
    customer = SalesEngine.customers
    customer.find_by_id(customer_id)
  end

  def is_paid_in_full?
    trans_repo = SalesEngine.transactions
    paid_trans = trans_repo.successful_transactions
    paid_invoices_ids = paid_trans.map { |trans| trans.invoice_id}
    if paid_invoices_ids.include?(id)
      true
    else
      false
    end
  end

  def total
    # returns the total $ amount of the invoice
    subtotals = items.map { |i_item| i_item.unit_price * i_item.quantity }
    #for each invoice item, multiply unit price by quantity
    total_bd = subtotals.reduce { |sum, num| (sum + num)}
    #add up subtotals for each invoice Item
    total_dollars = total_bd.to_f/100
    total_dollars.round(2)
    #turn to dollar amount
  end
end
