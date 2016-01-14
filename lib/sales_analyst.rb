require_relative '../lib/sales_engine'

class SalesAnalyst
  include Math

  attr_reader :sales_engine, :merchants, :items, :average, :merchant_ids, :merchant_items, :count

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = sales_engine.merchants
    @items = sales_engine.items
    @merchant_ids = []
  end

  def average_items_per_merchant
    @average = items.all.count.to_f / merchants.all.count.to_f
  end

  def find_all_merchant_ids
    merchants.all.each do |merchant|
      merchant_ids << merchant.id
    end
  end

  def find_all_merchant_items
    @merchant_items = merchant_ids.map do |merchant_id|
      items.find_all_by_merchant_id(merchant_id)
    end.reject { |element| element.empty?}
  end

  def count_items
      @count = merchant_items.map do |item_array|
      merch_id = item_array.first.merchant_id
      {merch_id => item_array.count}
    end
  end

  def average_items_per_merchant_standard_deviation
    hash_values = count.map do |hash|
      hash.values
    end.flatten

    square_differences = hash_values.map do |square_difference|
      (square_difference - average) ** 2
    end

    variance = square_differences.reduce do |sum, num|
      (sum + num) / square_differences.count
    end

    sqrt(variance)
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
