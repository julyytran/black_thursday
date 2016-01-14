require_relative '../lib/sales_engine'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    all_merchants = sales_engine.merchants
    merchant_ids = all_merchants.select do |id|
      id[:id]
    end

    all_items = sales_engine.items
    merchant_items = merchant_ids.each do |id|
    all_items.find_all_by_merchant_id(id)
    end

    merchant_items

  end

  def average_items_per_merchant_standard_deviation

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
