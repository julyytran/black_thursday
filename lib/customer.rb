class Customer
  attr_reader :data
  
  def initialize(data)
    @data = data
  end

  def id
    id = data[:id]
    id.to_s.to_i
  end

  def first_name
    data[:first_name]
  end

  def last_name
    data[:last_name]
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
