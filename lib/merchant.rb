class Merchant
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

  def created_at
    data[:created_at]
  end

  def updated_at
    data[:updated_at]
  end
end
