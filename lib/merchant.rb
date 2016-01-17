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
    merchant_id = id
    items = SalesEngine.items
    items.find_all_by_merchant_id(merchant_id)
  end

  def invoices
    merchant_id = id
    invoices = SalesEngine.invoices
    invoices.find_all_by_merchant_id(merchant_id)
  end

end
