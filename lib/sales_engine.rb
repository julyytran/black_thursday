require_relative '../lib/item_repository'
require_relative '../lib/merchant_repo'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction_repository'
require_relative '../lib/customer_repository'

class SalesEngine

 def self.from_csv(data)
   @data = data
   self.items
   self.merchants
   self.invoices
   self.invoice_items
   self.transactions
   self.customers
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

 def self.invoice_items
  InvoiceItemRepository.new(@data[:invoice_items])
 end

 def self.transactions
   TransactionRepository.new(@data[:transactions])
 end

 def self.customers
   CustomerRepository.new(@data[:customers])
 end
end
