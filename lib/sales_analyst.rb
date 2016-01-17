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
      hash.values[0].to_i > upper_bound
    end

    high_item_merch_ids = high_merch_item_pairs.map { |pair| pair.keys }.flatten
    high_item_merch_ids.map { |id| merchants.find_by_id(id) }
  end

  def average_item_price_for_merchant(merch_id)
    merchs_items = items.all.select { |item| item.merchant_id == merch_id }
    item_prices = merchs_items.map { |item| item.unit_price }
    result = item_prices.reduce { |sum, num| (sum + num) }

    rounded_result = result/(item_prices.count)/100
    rounded_result.round(2)
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

    rounded_result = result/(avg_prices_for_each_merch.count)
    rounded_result.round(2)
  end

  def golden_items
    all_item_prices
    avg_item_price
    item_sq_diffs
    item_variance

    item_stdev = sqrt(item_variance)
    upper_bound = (avg_item_price + (item_stdev*2))
    golden = items.all.select { |item| item.unit_price >= upper_bound }
  end

  def top_merchants_by_invoice_count
    threshold = average_invoices_per_merchant + two_stdevs
    invoices_by_merch = merchants.all.map { |merchant| merchant.invoices }
    most = invoices_by_merch.select { |group| group.length > threshold}
    top_merchs_ids = most.map { |group| group[0].merchant_id }
    top_merchs = top_merchs_ids.map { |id| merchants.find_by_id(id)}
  end

  def bottom_merchants_by_invoice_count
    threshold = average_invoices_per_merchant - two_stdevs
    invoices_by_merch = merchants.all.map { |merchant| merchant.invoices }
    least = invoices_by_merch.select { |group| group.length < threshold}
    bottom_merchs_ids = least.map { |group| group[0].merchant_id }
    bottom_merchs = bottom_merchs_ids.map { |id| merchants.find_by_id(id)}
  end

  def top_days_by_invoice_count
    avg_invoices_per_day = (invoices.all.count.to_f/7).round(2)
    invoices_each_day
    invoices_a_day = invoices_each_day.values
    days = invoices_each_day.keys
    invoice_counts = invoices_a_day.map { |invoice_group| invoice_group.count}
    days_and_invoice_counts = invoice_counts.zip(days).to_h

    square_differences = invoice_counts.map do |number|
        (number - avg_invoices_per_day) ** 2
    end

    variance = square_differences.reduce do |sum, num|
        (sum + num)
      end / (square_differences.count-1)

    stdev = sqrt(variance)
    threshold = avg_invoices_per_day + stdev

    matching_invoice_counts = invoice_counts.select do |number|
      number > threshold
    end

    top_days = matching_invoice_counts.map do |number|
      days_and_invoice_counts[number]
    end
  end

  def invoice_status(shipping_status)
      invoices_by_status = invoices.all.group_by { |invoice| invoice.status }
      status_count = invoices_by_status[shipping_status.to_s].count
      percent_status = ((status_count.to_f * 100.0) / invoices.all.count.to_f)
      percent_status.round(2)
  end
end
