require_relative '../lib/sales_engine'

class SalesAnalyst
  attr_reader :sales_engine, :merchants, :items, :average, :merchant_ids, :merchant_items

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = sales_engine.merchants
    @items = sales_engine.items
    @average = average
    @merchant_ids = merchant_ids
    @merchant_items = []
  end

  def average_items_per_merchant
    average = items.all.count.to_f / merchants.all.count.to_f
    average.round(2)
  end

  def find_all_merchant_ids
    merchant_ids = merchants.all.map do |merchant|
      merchant.id
    end
  end

  def find_all_merchant_items
    merchant_ids.each do |merchant_id|
      merchant_items << items.find_all_by_merchant_id(merchant_id)
    end
  end

  def count_items
    merchant_items.map do |items|
      
  end
  def average_items_per_merchant_standard_deviation
    #for each merchant item count subtract the mean
    #sq the result
    #take all the sq results
    #find the mean
    #then sq root of mean
  end

  def merchants_with_low_item_count # => [merchant, merchant, merchant]

  end

  def average_item_price_for_merchant(price) # => BigDecimal

  end

  def average_price_per_merchant # => BigDecimal

  end

  def golden_items # => [<item>, <item>, <item>, <item>]

  end
end
