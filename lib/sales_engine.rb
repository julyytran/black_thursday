require_relative '../lib/item_repository'
require_relative '../lib/merchant_repo'

class SalesEngine
 attr_accessor :items, :merchants

 def self.from_csv(data)
   sales_engine = self.new
   sales_engine.items = ItemRepository.new
   sales_engine.items.parse_data(data[:items])
   sales_engine.merchants = MerchantRepository.new
   sales_engine.merchants.parse_data(data[:merchants])
   sales_engine
 end
end
