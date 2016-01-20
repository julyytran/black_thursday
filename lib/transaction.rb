class Transaction
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data[:id].to_s.to_i
  end

  def invoice_id
    data[:invoice_id].to_s.to_i
  end

  def credit_card_number
    data[:credit_card_number].to_i
  end

  def credit_card_expiration_date
    data[:credit_card_expiration_date]
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

  def invoice
    @invoice ||= SalesEngine.invoices.find_by_id(invoice_id)
  end
end
