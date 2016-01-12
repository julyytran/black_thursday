require_relative '../lib/item_repository'
require_relative '../lib/merchant_repo'

class SalesEngine

  def self.from_csv(data)
    @data = data
    ItemRepository.new(data[:items])
    MerchantRepository.new(data[:merchant])
  end
end
