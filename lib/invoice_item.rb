class InvoiceItem
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    id = data[:id].to_s.to_i
  end

  def item_id
    data[:item_id].to_s.to_i
  end

  def invoice_id
    data[:invoice_id].to_s.to_i
  end

  def quantity
    data[:quantity].to_f
  end

  def unit_price
    if data[:unit_price].nil?
      BigDecimal.new(0)
    else
    BigDecimal.new(data[:unit_price], data[:unit_price].length)
  end
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
end
