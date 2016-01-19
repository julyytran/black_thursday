require_relative 'sales_engine'

class Item

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    id = data[:id]
    id.to_s.to_i
  end

  def merchant_id
    id = data[:merchant_id]
    id.to_s.to_i
  end

  def name
    data[:name]
  end

  def description
    data[:description]
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
    merchant = SalesEngine.merchants
    merchant.find_by_id(merchant_id)
  end
end
