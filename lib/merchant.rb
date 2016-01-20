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
    @items ||= SalesEngine.items.find_all_by_merchant_id(id)
  end

  def items_count
    items.count
  end

  def items_prices
    @items_prices ||= items.map {|item| item.unit_price}
  end

  def invoices
    @invoices ||= SalesEngine.invoices.find_all_by_merchant_id(id)
  end

  def invoices_count
    invoices.count
  end

  def customers
    @customers ||= invoices.map { |invoice| SalesEngine.customers.find_by_id(invoice.customer_id) }.uniq
  end
end
