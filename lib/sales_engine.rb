require_relative '../lib/item_repository'
require_relative '../lib/merchant_repo'

class SalesEngine

  attr_reader :data

  def from_csv(data)
    @data = data
  end

  def items
     @items = ItemRepository.new(data[:items])
  end

  def merchants
    @merhcants = MerchantRepository.new(data[:merchants])
  end
end
