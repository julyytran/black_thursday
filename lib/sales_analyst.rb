require_relative '../lib/sales_engine'
require_relative '../lib/calculations.rb'

class SalesAnalyst
  include Math
  include StandardDeviation

  attr_reader :sales_engine, :merchants, :items, :invoices, :transactions,
              :invoice_items, :custs

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = sales_engine.merchants
    @items = sales_engine.items
    @invoices = sales_engine.invoices
    @custs = sales_engine.customers
    @transactions = sales_engine.transactions
    @invoice_items = sales_engine.invoice_items
  end

  def average_items_per_merchant
    average_objects_per_merchant(items)
  end

  def average_invoices_per_merchant
    average_objects_per_merchant(invoices)
  end

  def average_items_per_merchant_standard_deviation
    sq_diffs = merchants.merchant_item_count.map do |number|
      (number - average_items_per_merchant) ** 2
    end
    stdev_from_sq_diffs(sq_diffs)
  end

  def average_invoices_per_merchant_standard_deviation
    sq_diffs = merchants.merchant_invoice_count.map do |number|
      (number - average_invoices_per_merchant) ** 2
    end
    stdev_from_sq_diffs(sq_diffs)
  end

  def merchants_with_high_item_count
    stdev = average_items_per_merchant_standard_deviation
    threshold = (average_items_per_merchant + stdev)
    merchants.all.select{|merchant| merchant.items_count > threshold}
  end

  def average_item_price_for_merchant(merch_id)
    avg_cents = average_item_price_for_merchant_in_cents(merch_id)
    dollars = (avg_cents/100).round(2)
  end

  def average_item_price_for_merchant_in_cents(merch_id)
    merchant = merchants.find_by_id(merch_id)
    merchant_total_price = merchant.items_prices.reduce { |sum, num|
      (sum + num) }
    @avg_cents = merchant_total_price/(merchant.items_prices.count)
  end

  def average_average_price_per_merchant
    find_merchant(items)
    count_data(items)

    merch_ids_with_items = count_data(items).map { |hash| hash.keys }.flatten

    avg_prices_for_each_merch = merch_ids_with_items.map do |merch_id|
      average_item_price_for_merchant_in_cents(merch_id)
    end

    result = avg_prices_for_each_merch.reduce { |sum, num| (sum + num) }

    avg = result/(merchants.all.count)
    dollars = avg/100
    dollars.round(2)
  end

  def golden_items
    item_sq_diffs = items.all_item_prices.map do |number|
      (number - items.avg_item_price) ** 2
    end

    item_stdev = stdev_from_sq_diffs(item_sq_diffs)
    threshold = (items.avg_item_price + (item_stdev*2))
    golden = items.all.select { |item| item.unit_price >= threshold }
  end

  def top_merchants_by_invoice_count
    threshold = average_invoices_per_merchant + two_stdevs
    most = merchants.all.select { |merchant|
      merchant.invoices_count > threshold }
  end

  def bottom_merchants_by_invoice_count
    threshold = average_invoices_per_merchant - two_stdevs
    least = merchants.all.select { |merchant|
      merchant.invoices_count < threshold }
  end

  def top_days_by_invoice_count
    avg_invoices_per_day = (invoices.all.count.to_f/7).round(2)
    invoice_counts = invoices.invoices_each_day.values.map { |invoice_group|
      invoice_group.count}
    days = invoices.invoices_each_day.keys
    days_and_invoice_counts = invoice_counts.zip(days).to_h

    sq_diffs = invoice_counts.map do |number|
        (number - avg_invoices_per_day) ** 2
    end

    stdev = stdev_from_sq_diffs(sq_diffs)
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
      status_count = invoices_by_status[shipping_status].count
      percent_status = ((status_count.to_f * 100.0) / invoices.all.count.to_f)
      percent_status.round(2)
  end

  def top_revenue_earners(x = 20)
    merchants_ranked_by_revenue[0,x]
  end

  def merchants_with_pending_invoices
    merchants.all.find_all do |merchant|
      merchant.invoices.any?{|invoice| !invoice.is_paid_in_full?}
    end
  end

  def merchants_with_only_one_item
    merchants.all.select{ |merch| merch.items_count == 1}
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.select do |merch|
      merch.created_at.month == Time.parse(month).month
    end
  end

  def revenue_by_merchant(merchant_id)
    merch = merchants.find_by_id(merchant_id)
    merch.items_prices.reduce(:+)
  end

  def total_revenue_by_date(date)
   invoice_ids = invoices.find_all_by_date_created(date.to_s)
   total_revenue = invoice_ids.map { |invoice| invoice.total }
   final = total_revenue.map { |revenue| revenue }.reduce(:+)
 end

  def merchants_ranked_by_revenue
    revenues = merchants.all.map do |merch|
      if merch.revenue.nil?
        0
      else
        merch.revenue
      end
    end

    ids_to_rev = merchants.merchant_ids.zip(revenues).to_h
    ranked = ids_to_rev.sort_by {|k, v| v}.reverse
    final_rank = ranked.reject {|mini_ar| mini_ar[1] == 0}

    merchs = final_rank.map {|id_rev| merchants.find_by_id(id_rev[0])}
  end

  def most_sold_item_for_merchant(merchant_id)
    merch = merchants.find_by_id(merchant_id)

    quantities = merch.invoice_items_paid_in_full.map {|i_item| i_item.quantity}
    ids = merch.invoice_items_paid_in_full.map(&:item_id)

    item_ids_to_qs = ids.zip(quantities).to_h
    ranked = item_ids_to_qs.sort_by {|k, v| v}.reverse

    max = ranked[0][1]

    most_sold_ids = ranked.to_h.select {|k, v| v == max}.keys
    most_sold = most_sold_ids.map {|id| items.find_by_id(id)}
  end

  def best_item_for_merchant(merchant_id)
    merch = merchants.find_by_id(merchant_id)
    revenues = merch.invoice_items_paid_in_full.map {|i_item|
      i_item.quantity * i_item.unit_price}
    ids = merch.invoice_items_paid_in_full.map(&:item_id)

    item_ids_to_qs = ids.zip(revenues).to_h
    ranked = item_ids_to_qs.sort_by {|k, v| v}.reverse
    id = ranked[0][0]
    best = items.find_by_id(id)
  end
end
