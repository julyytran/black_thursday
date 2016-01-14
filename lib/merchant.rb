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
    DateTime.strptime(data[:created_at], "%F %T")
  end

  def updated_at
    DateTime.strptime(data[:updated_at], "%F %T")
  end

  def items
    merchant_id = id
    items = SalesEngine.items
    items.find_all_by_merchant_id(merchant_id)
  end
#extract merchant id from merchant object  call id method to extract
#create an item repository object
#pass in merchant id into the find by method that is called on the item repo object
#
end
