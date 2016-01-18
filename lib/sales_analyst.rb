require_relative '../lib/sales_engine'
require_relative '../lib/calculations.rb'

class SalesAnalyst
  include Math
  include Calculations

  attr_reader :sales_engine, :merchants, :items, :invoices, :transactions, :invoice_items, :custs

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = sales_engine.merchants
    @items = sales_engine.items
    @invoices = sales_engine.invoices
    @custs = sales_engine.customers
    @transactions = sales_engine.transactions
    @invoice_items = sales_engine.invoice_items
  end

  def successful_invoices
    successful_transactions = transactions.successful_transactions
    successsful_invoice_ids = successful_transactions.map {|transaction| transaction.invoice_id}
    successsful_invoice_ids.map {|id| invoices.find_by_id(id)}
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

  def average_item_price_for_merchant_in_cents(merch_id)
    merchs_items = items.all.select { |item| item.merchant_id == merch_id }
    item_prices = merchs_items.map { |item| item.unit_price }
    result = item_prices.reduce { |sum, num| (sum + num) }
    result/(item_prices.count)
  end

  def average_item_price_for_merchant(merch_id)
    rounded_result = average_item_price_for_merchant_in_cents(merch_id)
    rounded_result/100
    rounded_result.round(2)
  end

  def average_average_price_per_merchant
    find_all_merchant_ids
    find_merchant(items)
    count_data(items)

    merch_ids_with_items = count_data(items).map { |hash| hash.keys }.flatten

    avg_prices_for_each_merch = merch_ids_with_items.map do |merch_id|
      average_item_price_for_merchant_in_cents(merch_id)
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

  def merchant_revenue_by_date(date)
    transactions_by_given_date = transactions.all.select do |trans|
      if trans.created_at.to_s.include?(date)
        0
      else
        trans.created_at.to_s.include?(date) && trans.result == "success"
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
    all_invoice_total = successful_invoices.map { |invoice| invoice.total }
    inv_repo_w_totals = successful_invoices
    merchant_to_invoices = inv_repo_w_totals.group_by { |invoice|
      invoice.merchant_id}
    invoice_values = merchant_to_invoices.values
    merchant_ids = merchant_to_invoices.keys
    merchant_revenue_subtotals = invoice_values.map { |invoice_group|
      invoice_group.map { |invoice| invoice.total } }
    merchant_invoice_totals = merchant_revenue_subtotals.map { |subtotal_group|
      subtotal_group.reduce { |sum, subtotal| (sum + subtotal) } }
    merchant_totals = merchant_ids.zip(total_invoice_price_by_merchant).to_h
    high_to_low = merchant_totals.sort_by { |k,v| v}.reverse.to_h.keys
    top_merchants = high_to_low[0,x]
    top_merchants.map { |merchant_id| merchants.find_by_id(merchant_id) }
  end

  def top_buyers(x)
    all_inv_totals = successful_invoices.map { |invoice| invoice.total }
    inv_repo_w_totals = successful_invoices
    customer_to_invoices = inv_repo_w_totals.group_by { |invoice| invoice.customer_id}
    invoices_by_cust = customer_to_invoices.values
    cust_ids = customer_to_invoices.keys
    subtotals_by_cust = invoices_by_cust.map { |invoice_group| invoice_group.map { |invoice| invoice.total}}
    total_invoice_price_by_cust = subtotals_by_cust.map { |subtotal_group| subtotal_group.reduce { |sum, subtotal| (sum + subtotal) } }
    cust_to_spending = cust_ids.zip(total_invoice_price_by_cust).to_h
    high_to_low = cust_to_spending.sort_by {|k, v| v}.reverse
    top_x_cust_ids = high_to_low.to_a[0..(x-1)].to_h.keys
    top_x_cust_ids.map { |id| custs.find_by_id(id) }
  end

  def merchants_with_pending_invoices #=> [merchant, merchant, merchant]
    failed_transactions = transactions.all.select do |trans|
      trans.result == 'failed'
    end
    invoice_ids = failed_transactions.map { |tran| tran.invoice_id }
    pending_invoices = invoice_ids.map { |invoice| invoices.find_by_id(invoice) }
    merchant_ids = pending_invoices.map { |invoice| invoice.merchant_id }
    merchant_ids.map { |merchant_id| merchants.find_by_id(merchant_id) }
  end

  def merchants_with_only_one_invoice #=> [merchant, merchant, merchant]
    #iterate over all transactions and collect 
  end
end



#search all successful transactions
#collect all invoice_item_repo objects that match  invoice_ids from successful transactions
