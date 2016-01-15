require_relative '../lib/sales_engine'
require 'pry'

class SalesAnalyst
  include Math

  attr_reader :sales_engine, :merchants, :items, :invoices, :average_items,         :average_invoices, :merchant_ids, :merchant_items, :item_count, :item_collection,
  :square_differences, :variance, :stdev, :invoice_count, :invoice_collection, :merchant_invoices, :invoice_square_differences

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = sales_engine.merchants
    @invoices = sales_engine.invoices
    @items = sales_engine.items
  end

  def average_items_per_merchant
    @average_items = items.all.count.to_f / merchants.all.count.to_f
  end

  def find_all_merchant_ids
    @merchant_ids = merchants.all.map do |merchant|
      merchant.id
    end
  end

  def find_all_merchant_items
    @merchant_items = merchant_ids.map do |merchant_id|
      items.find_all_by_merchant_id(merchant_id)
    end.reject { |element| element.empty?}
  end

  def count_items
    @item_count = merchant_items.map do |item_array|
      merch_id = item_array.first.merchant_id
      {merch_id => item_array.count}
    end
  end

  def collect_item_counts
    @item_collection = item_count.map do |hash|
      hash.values
    end.flatten
  end

  def collect_square_differences
    @square_differences = item_collection.map do |number|
      (number - average_items) ** 2
    end
  end

  def variance
    @variance = square_differences.reduce do |sum, num|
      (sum + num)
    end / (square_differences.count-1)
  end

  def average_items_per_merchant_standard_deviation
    average_items_per_merchant
    find_all_merchant_ids
    find_all_merchant_items
    count_items
    collect_item_counts
    collect_square_differences
    variance
    @stdev = sqrt(variance)
  end

  def merchants_with_low_item_count
    average_items_per_merchant_standard_deviation
    lower_bound = (average_items-stdev)

    low_merch_item_pairs = item_count.select {|hash| hash.values[0].to_i < lower_bound}

    low_item_merch_ids = low_merch_item_pairs.map do |pair|
      pair.keys
    end.flatten

    low_item_merch_ids.map do |id|
      merchants.find_by_id(id)
    end
  end

  def average_item_price_for_merchant(merch_id)
    merchs_items = items.all.select do |item|
      item.merchant_id == merch_id
    end

    item_prices = merchs_items.map do |item|
      item.unit_price
    end
    result = item_prices.reduce do |sum, num|
      (sum + num)
    end
  result2 = result/(item_prices.count)
  end

  def average_average_price_per_merchant
    find_all_merchant_ids
    find_all_merchant_items
    count_items

    merch_ids_with_items = item_count.map do |hash|
        hash.keys
      end.flatten

    avg_prices_for_each_merch = merch_ids_with_items.map do |merch_id|
      average_item_price_for_merchant(merch_id)
    end

    result = avg_prices_for_each_merch.reduce do |sum, num|
      (sum + num)
    end
    result/(avg_prices_for_each_merch.count)
  end

  def golden_items
    all_item_prices = items.all.map do |item|
      item.unit_price
    end

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

    golden = items.all.select do |item|
      item.unit_price >= upper_bound
    end
  end

  def average_invoices_per_merchant
    @average_invoices = invoices.all.count.to_f / merchants.all.count.to_f
    average_invoices.round(2)
  end

  def find_all_merchant_invoices
    @merchant_invoices = merchant_ids.map do |merchant_id|
      invoices.find_all_by_merchant_id(merchant_id)
    end.reject { |element| element.empty?}
  end

  def count_invoices
    @invoice_count = merchant_invoices.map do |item_array|
      merch_id = item_array.first.merchant_id
      {merch_id => item_array.count}
    end
  end

  def collect_invoice_counts
    @invoice_collection = invoice_count.map do |hash|
      hash.values
    end.flatten
  end

  def collect_invoice_square_differences
    @invoice_square_differences = invoice_collection.map do |number|
      (number - average_invoices) ** 2
    end
  end

  def invoice_variance
    @invoice_variance = invoice_square_differences.reduce do |sum, num|
      (sum + num)
    end / (invoice_square_differences.count-1)
  end

  def average_invoices_per_merchant_standard_deviation
    average_invoices_per_merchant
    find_all_merchant_ids
    find_all_merchant_invoices
    count_invoices
    collect_invoice_counts
    collect_invoice_square_differences
    invoice_variance
    @invoice_stdev = sqrt(invoice_variance).round(2)
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
