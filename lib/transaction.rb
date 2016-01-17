class Transaction

  def initialize(data)
    @data = data
  end

  def id
    id = data[:id]
    id.to_s.to_i
  end

  def invoice_id
    id = data[:invoice_id]
    id.to_s.to_i
  end

  def credit_card_number
    data[:credit_card_number]
  end

  def result
    data[:result]
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
