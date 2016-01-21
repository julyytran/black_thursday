require 'time'
module Calculations

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
