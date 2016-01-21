class Item
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data[:id].to_s.to_i
  end

  def merchant_id
    data[:merchant_id].to_s.to_i
  end

  def name
    data[:name]
  end

  def description
    data[:description]
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

  def merchant
    @merchant ||= SalesEngine.merchants.find_by_id(merchant_id)
  end
end
