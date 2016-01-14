require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items    => './data/items.csv',
      :merchants => './data/merchants.csv'})
      @sa = SalesAnalyst.new(se)
  end

  def test_average_items_per_merchant
    skip
    assert_equal 0.0, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    skip
    assert_equal 0.0, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_low_item_count
    skip
    merchant_list = sa.merchants_with_low_item_count
    refute merchant_list.empty?
    assert_equal Merchant, merchant_list[0].class 
  end

  def test_average_item_price_for_merchant
    skip
    avg = sa.average_item_price_for_merchant("12334112")
    assert_equal BigDecimal, avg.class
    assert_equal avg.inspect.include?("ANSWER")
  end

  def test_average_price_per_merchant
    skip
    avg = sa.average_price_for_merchant
    assert_equal BigDecimal, avg.class
    assert_equal avg.inspect.include?("ANSWER")
  end

  def test_golden_items
    skip
    golden = sa.golden_items
    refute golden.empty?
    assert_equal Item, golden[0].class
  end

end
