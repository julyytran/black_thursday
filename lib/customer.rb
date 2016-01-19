require 'time'

class Customer
  attr_reader :data

  def inspect
    "#<#{self.class}"
  end

  def initialize(data)
    @data = data
  end

  def id
    id = data[:id]
    id.to_s.to_i
  end

  def first_name
    data[:first_name]
  end

  def last_name
    data[:last_name]
  end

  def created_at
    Time.parse(data[:created_at])
  end

  def updated_at
    Time.parse(data[:updated_at])
  end

  def merchants
    invoices = SalesEngine.invoices
    cust_invoices = invoices.find_all_by_customer_id(id)
    cust_invoices.map { |invoice| invoice.merchant}
  end
end
