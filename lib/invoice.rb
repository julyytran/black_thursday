require_relative 'sales_engine'
class Invoice
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data[:id]
  end

  def customer_id
    data[:customer_id]
  end

  def merchant_id
    data[:merchant_id]
  end

  def status
    data[:status]
  end

  def created_at
    DateTime.strptime(data[:created_at], "%F")
  end

  def updated_at
    DateTime.strptime(data[:updated_at], "%F")
  end

  def merchant
    merchant_id = merchant_id
    se = SalesEngine.merchants
    se.find_by_id(merchant_id)
  end
end
