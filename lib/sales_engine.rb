require_relative '../lib/item_repository'
require_relative '../lib/merchant_repo'
require_relative '../lib/invoice_repository'

class SalesEngine

 def self.from_csv(data)
   @data = data
   self.items
   self.merchants
   self.invoices
   self
 end

 def self.items
   ItemRepository.new(@data[:items])
 end

 def self.merchants
   MerchantRepository.new(@data[:merchants])
 end

 def self.invoices
   InvoiceRepository.new(@data[:invoices])
 end

end
