class Item

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def contents
    data[:contents]
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
    data[:unit_price]
  end

  def created_at
    data[:created_at]
  end

  def updated_at
    data[:updated_at]
  end

end
