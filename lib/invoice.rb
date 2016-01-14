class Invoice
attr_reader :data

def initialize(data)
  @data = data
end

def id
  data[:id]
end

def customer_id
  data[:customer_id]
end

def merchant_id
  data[:merchant_id]
end

def status
  data[:status]
end

def created_at
  data[:created_at]
end

def updated_at
  data[:updated_at]
end

def merchants
  se = SalesEngine
  m = MerchantRepository.new
  m.find_by_id(merchant_id)
end
end
