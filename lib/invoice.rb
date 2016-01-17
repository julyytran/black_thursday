require "time"
require_relative 'sales_engine'

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
    mr = SalesEngine.merchants
    mr.find_by_id(merchant_id)
  end

  def is_paid_in_full?
    trans_repo = SalesEngine.transactions
    paid_trans = trans_repo.successful_transactions

    if paid_trans.each { |trans| trans.invoice_id == id}
      true
    else
      false
    end
  end

  def total
    # returns the total $ amount of the invoice

  end
end
# Failed charges should never be counted in revenue totals or statistics.
