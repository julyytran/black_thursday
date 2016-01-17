module Calculations

  def average_objects_per_merchant(objects)
    (objects.all.count.to_f/merchants.all.count.to_f).round(2)
  end

  def standard_deviation_objects_per_merchant(objects)
    average_objects_per_merchant(objects)
    find_all_merchant_ids
    find_merchant(objects)
    count_data(objects)
    collect_data_counts(objects)
    collect_square_differences(objects)
    sqrt(variance(objects)).round(2)
  end

  def two_stdevs
    stdev = average_invoices_per_merchant_standard_deviation
    stdev * 2
  end

  def find_all_merchant_ids
    merchants.all.map { |merchant| merchant.id }
  end

  def find_merchant(data)
    find_all_merchant_ids.map do |merchant_id|
      data.find_all_by_merchant_id(merchant_id)
    end.reject { |element| element.empty?}
  end

  def count_data(data)
    find_merchant(data).map do |data_array|
      merch_id = data_array.first.merchant_id
      { merch_id => data_array.count }
    end
  end

  def collect_data_counts(data)
    count_data(data).map { |hash| hash.values }.flatten
  end

  def collect_square_differences(data)
    collect_data_counts(data).map do |number|
      (number - average_items_per_merchant) ** 2
    end
  end

  def variance(data)
    collect_square_differences(data).reduce do |sum, num|
      (sum + num)
    end / (collect_square_differences(data).count-1)
  end

  def all_item_prices
    items.all.map { |item| item.unit_price }
  end

  def avg_item_price
    all_item_prices.reduce do |sum, num|
      (sum + num)
    end/(all_item_prices.count)
  end

  def item_sq_diffs
    all_item_prices.map do |number|
      (number - avg_item_price) ** 2
    end
  end

  def item_variance
    item_sq_diffs.reduce do |sum, num|
      (sum + num)
    end / (item_sq_diffs.count-1)
  end

  def invoices_each_day
    invoices.all.group_by do |invoice|
      invoice.created_at.strftime("%A")
    end
  end

end
