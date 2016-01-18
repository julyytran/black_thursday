
class Merchant

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    id = data[:id]
    id.to_i
  end

  def name
    data[:name]
  end

  def created_at
    Time.parse(data[:created_at])
  end

  def updated_at
    Time.parse(data[:updated_at])
  end

  def items
    items = SalesEngine.items
    items.find_all_by_merchant_id(id)
  end

  def invoices
    invoices = SalesEngine.invoices
    invoices.find_all_by_merchant_id(id)
  end

  def customers
    cust_ids = invoices.map { |invoice| invoice.customer_id}
    cust_repo = SalesEngine.customers
    cust_ids.map { |id| cust_repo.find_by_id(id)}
  end

end
