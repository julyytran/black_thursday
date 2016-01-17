class InvoiceItem
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    id = data[:id]
    id.to_s.to_i
  end

  def item_id
    data[:item_id]
  end

  def invoice_id
    data[:invoice_id]
  end

  def quantity
    data[:quantity]
  end

  def unit_price
    BigDecimal.new(data[:unit_price], data[:unit_price].length)
  end

  def unit_price_to_dollars
    unit_price.to_f / 100
  end

  def created_at
    Time.parse(data[:created_at])
  end

  def updated_at
    Time.parse(data[:updated_at])
  end

  def merchant
    mi = merchant_id
    merchant = SalesEngine.merchants
    merchant.find_by_id(mi)
  end
end
