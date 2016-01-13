class Item

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data[:id]
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

  def created_at
    DateTime.strptime(data[:created_at], "%F %T")
  end

  def updated_at
    DateTime.strptime(data[:updated_at], "%F %T")
  end

  def merchant_id
    data[:merchant_id]
  end

end
