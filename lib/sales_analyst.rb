require_relative '../lib/sales_engine'
require_relative '../lib/calculations.rb'

class SalesAnalyst
  include Math
  include Calculations

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
    sq_diffs = merchant_item_count.map do |number|
      (number - average_items_per_merchant) ** 2
    end
    stdev_from_sq_diffs(sq_diffs)
  end

  def average_invoices_per_merchant_standard_deviation
    sq_diffs = merchant_invoice_count.map do |number|
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
    merchant_total_price = merchant.items_prices.reduce { |sum, num| (sum + num) }
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
    all_item_prices
    avg_item_price
    item_sq_diffs
    item_stdev = stdev_from_sq_diffs(item_sq_diffs)
    threshold = (avg_item_price + (item_stdev*2))
    golden = items.all.select { |item| item.unit_price >= threshold }
  end

  def top_merchants_by_invoice_count
    threshold = average_invoices_per_merchant + two_stdevs
    most = merchants.all.select { |merchant| merchant.invoices_count > threshold }
  end

  def bottom_merchants_by_invoice_count
    threshold = average_invoices_per_merchant - two_stdevs
    least = merchants.all.select { |merchant| merchant.invoices_count < threshold}
  end

  def top_days_by_invoice_count
    avg_invoices_per_day = (invoices.all.count.to_f/7).round(2)
    invoice_counts = invoices_each_day.values.map { |invoice_group| invoice_group.count}
    days = invoices_each_day.keys
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

  def total_revenue_by_date(date)
    # => $$
    transactions_by_given_date = transactions.all.select do |trans|
      if trans.created_at.to_s.include?(date.to_s)
        0
      else
        trans.created_at.to_s.include?(date.to_s) && trans.result == "success"
      end
    end

    invoice_id = transactions_by_given_date.map { |trans| trans.invoice_id }

    item_id = invoice_id.map do |id|
      invoice_items.find_all_by_invoice_id(id)
    end.flatten

    price_by_quantity = item_id.map do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity.to_i
    end
    price_by_quantity.reduce(:+).to_f/100
  end

  def top_revenue_earners(x = 20)
    # => [merchant, merchant, merchant]
    # merchant_to_invoices = successful_invoices.group_by(&:merchant_id)
    # invoice_values = merchant_to_invoices.values
    # merchant_ids = merchant_to_invoices.keys
    merchant_revenue_subtotals = merchant_invoices.map { |invoice_group|
      invoice_group.map { |invoice| invoice.total } }

    merchant_invoice_totals = merchant_revenue_subtotals.map { |subtotal_group|
      subtotal_group.reduce { |sum, subtotal| (sum + subtotal) } }

    merchant_totals = merchant_ids.zip(merchant_invoice_totals).to_h
    high_to_low = merchant_totals.sort_by { |k,v| v}.reverse.to_h.keys
    top_merchants = high_to_low[0,x]
    top_merchants.map { |merchant_id| merchants.find_by_id(merchant_id) }
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
    merch.items_prices.reduce(:+) #invoice item prices?
  end

  def total_revenue_by_date(date)
   invoice_ids = invoices.find_all_by_date_created(date.to_s)
   total_revenue = invoice_ids.map { |invoice| invoice.total }
   final = total_revenue.map { |revenue| revenue }.reduce(:+)
 end

  def merchants_ranked_by_revenue
    merchants.all.pop
    # require 'pry'
    # binding.pry
    merchs = merchants.all.sort_by {|merch| merch.invoice_items_prices.reduce(:+)}
    # all_merch_revenue = merchants.all.map {|merch| merch.items_prices.reduce(:+)}
    # require 'pry'
    # binding.pry
    # full_merch_revenue = all_merch_revenue.reject {|num| num.nil?}
    # ids = merch_ids.sort_by.with_index do |num, index|
    #   full_merch_revenue[index]
    #   merchants.
    # end
    # all_merch_revenue.sort
  end

  def most_sold_item_for_merchant(merchant_id)
  #=> [item] (in terms of quantity sold)
    merch = merchants.find_by_id(merchant_id)
    most_sold_item_ids = merch.most_sold_item_ids
    most_sold = most_sold_item_ids.map {|id| items.find_by_id(id)}
# require 'pry'
# binding.pry
  end

  def best_item_for_merchant(merchant_id)
    #=> item (in terms of revenue generated)

  end
end
