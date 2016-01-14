require_relative '../lib/item_repository'
require_relative '../lib/merchant_repo'

class SalesEngine

 def self.from_csv(data)
   @data = data
   self.items
   self.merchants
   self
 end

 def self.items
   ItemRepository.new(@data[:items])
 end

 def self.merchants
   MerchantRepository.new(@data[:merchants])
 end
end
