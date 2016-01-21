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


  end

  def merchants_with_pending_invoices #=> [merchant, merchant, merchant]
    pending_invoices = successful_invoices.select { |invoice| invoice.status == :pending}
    merch_ids = pending_invoices.map { |invoice| invoice.merchant_id }.uniq
    merchs = merch_ids.map { |merchant_id| merchants.find_by_id(merchant_id) }


    # failed_transactions = transactions.all.select do |trans|
    #   trans.result == 'failed'
    # end
    # invoice_ids = failed_transactions.map { |tran| tran.invoice_id }
    # pending_invoices = invoice_ids.map {|invoice| invoices.find_by_id(invoice)}
    # merchant_ids = pending_invoices.map { |invoice| invoice.merchant_id }
    # merchant_ids.map { |merchant_id| merchants.find_by_id(merchant_id) }
  end

  def merchants_with_only_one_item
    # => [merchant, merchant, merchant]

  end

  def merchants_with_only_one_item_registered_in_month(month)
    # => [merchant, merchant, merchant]

  end

  def revenue_by_merchant(merchant_id)
    # => $$

  end

  def most_sold_item_for_merchant(merchant_id)
  #=> [item] (in terms of quantity sold)

  end

  def best_item_for_merchant(merchant_id)
    #=> item (in terms of revenue generated)

  end
end
