require_relative '../lib/sales_engine'
require_relative '../lib/calculations.rb'

class SalesAnalyst
  include Math
  include Calculations

  attr_reader :sales_engine, :merchants, :items, :invoices

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = sales_engine.merchants
    @invoices = sales_engine.invoices
    @items = sales_engine.items
  end

  def average_items_per_merchant
    average_objects_per_merchant(items)
  end

  def average_invoices_per_merchant
    average_objects_per_merchant(invoices)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation_objects_per_merchant(items)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation_objects_per_merchant(invoices)
  end

  def merchants_with_high_item_count
    stdev = average_items_per_merchant_standard_deviation
    upper_bound = (average_items_per_merchant + stdev)

    high_merch_item_pairs = count_data(items).select do |hash|
      hash.values[0].to_i < upper_bound
    end

    high_item_merch_ids = high_merch_item_pairs.map { |pair| pair.keys }.flatten

    high_item_merch_ids.map { |id| merchants.find_by_id(id) }
  end

  def average_item_price_for_merchant(merch_id)
    merchs_items = items.all.select { |item| item.merchant_id == merch_id }

    item_prices = merchs_items.map { |item| item.unit_price }

    result = item_prices.reduce { |sum, num| (sum + num) }

    result/(item_prices.count)
  end

  def average_average_price_per_merchant
    find_all_merchant_ids
    find_merchant(items)
    count_data(items)

    merch_ids_with_items = count_data(items).map { |hash| hash.keys }.flatten

    avg_prices_for_each_merch = merch_ids_with_items.map do |merch_id|
      average_item_price_for_merchant(merch_id)
    end

    result = avg_prices_for_each_merch.reduce { |sum, num| (sum + num) }

    result/(avg_prices_for_each_merch.count)
  end

  def golden_items
    all_item_prices = items.all.map { |item| item.unit_price }

    avg_item_price = all_item_prices.reduce do |sum, num|
      (sum + num)
    end/(all_item_prices.count)

    item_sq_diffs = all_item_prices.map do |number|
      (number - avg_item_price) ** 2
    end

    item_variance = item_sq_diffs.reduce do |sum, num|
      (sum + num)
    end / (item_sq_diffs.count-1)

    item_stdev = sqrt(item_variance)

    upper_bound = (avg_item_price + (item_stdev*2))

    golden = items.all.select { |item| item.unit_price >= upper_bound }
  end

  def top_merchants_by_invoice_count  #=> [merchant, merchant, merchant]
      # Which merchants are more than two standard deviations above the mean?
  end

  def bottom_merchants_by_invoice_count # => [merchant, merchant, merchant]
    # Which merchants are more than two standard deviations below the mean?
  end

  def top_days_by_invoice_count # => ["Sunday", "Saturday"]

  end

  def invoice_status(status)
      # What percentage of invoices are "shipped" vs "pending"?
  end
end
