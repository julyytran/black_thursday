class Merchant

  attr_reader :data, :i_items

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
    if items.nil?
      return 0
    else
    items_prices = items.map {|item| item.unit_price}
    end
  end

  def revenue
    paid = invoices.select { |invoice| invoice.is_paid_in_full? }
    subtotals = paid.map {|invoice| invoice.total}.reduce(:+)
  end

  def invoice_items_prices
    invoice_items_prices = invoice_items.map {|i_item_group|
      i_item_group.map(&:unit_price)}.reduce(:+)
  end

  def invoices
    @invoices ||= SalesEngine.invoices.find_all_by_merchant_id(id)
  end

  def invoices_count
    invoices.count
  end

  def invoice_items
    invoice_ids = invoices.map(&:id)
    @i_items ||= SalesEngine.invoice_items
    invoice_items = invoice_ids.flat_map {|invoice_id|
      i_items.find_all_by_invoice_id(invoice_id)}
  end

  def invoice_items_paid_in_full
    paid_invoices = invoices.select {|invoice| invoice.is_paid_in_full?}
    ii_item = paid_invoices.flat_map {|invoice| invoice.invoice_items}
  end

  def customers
    @customers ||= invoices.map { |invoice|
      SalesEngine.customers.find_by_id(invoice.customer_id) }.uniq
  end
end
