require 'time'
module Calculations

  # def merchant_ids
  #   @merchant_ids ||= merchants.all.map { |merchant| merchant.id }
  # end

  # def merchant_items
  #   @merchant_items ||= merchants.map(&:item).reject { |element| element.empty?}
  # end

  # def merchant_invoices
  #   @merchant_invoices ||= merchants.all.map(&:invoices)
  # end

  # def merchant_item_count
  #   @merchant_item_count ||= merchants.all.map(&:items_count)
  # end

  # def merchant_invoice_count
  #   @merchant_invoice_count ||= merchants.all.map(&:invoices_count)
  # end

  # def merchant_items_prices
  #   @merchant_items_prices ||= merchants.all.map(&:items_prices)
  # end

  def average_objects_per_merchant(objects)
    (objects.all.count.to_f/merchants.all.count.to_f).round(2)
  end

  def stdev_from_sq_diffs(sq_diffs)
    sum = sq_diffs.reduce { |sum, num| (sum + num) }
    var = sum/(sq_diffs.count-1)
    stdev = sqrt(var).round(2)
  end

  def two_stdevs
    stdev = average_invoices_per_merchant_standard_deviation
    stdev * 2
  end

  # def all_item_prices
  #   @all_item_prices ||= items.all.map { |item| item.unit_price }
  # end

  # def avg_item_price
  #   @avg_item_price ||= all_item_prices.reduce do |sum, num|
  #     (sum + num)
  #   end/(all_item_prices.count)
  # end

  def item_sq_diffs
    @item_sq_diffs ||= items.all_item_prices.map do |number|
      (number - items.avg_item_price) ** 2
    end
  end

  def invoices_each_day
    @invoices_each_day ||= invoices.all.group_by do |invoice|
      invoice.created_at.strftime("%A")
    end
  end

  def find_merchant(data)
      merchants.merchant_ids.map do |merchant_id|
        data.find_all_by_merchant_id(merchant_id)
      end.reject { |element| element.empty?}
    end

    def count_data(data)
      find_merchant(data).map do |data_array|
        merch_id = data_array.first.merchant_id
        { merch_id => data_array.count }
      end
    end

end
