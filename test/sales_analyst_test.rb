require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items    => './data/fixtures/items.csv',
      :merchants => './data/fixtures/merchants.csv'})
    @sa = SalesAnalyst.new(se)
  end

  def test_average_items_per_merchant
    assert_equal 7.232323232323233, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 5.64346953806178, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_low_item_count
    merchant_list = sa.merchants_with_low_item_count
    refute merchant_list.empty?
    assert_equal Merchant, merchant_list[0].class
  end

  def test_average_item_price_for_merchant
    avg = sa.average_item_price_for_merchant("12334195")
    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.48335E5')
  end

  def test_average_price_per_merchant
    avg = sa.average_average_price_per_merchant
    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.1300984840 2537485582 4682811764 7058823529 41E6')
  end

  def test_golden_items
    golden = sa.golden_items
    refute golden.empty?
    assert_equal Item, golden[0].class
    assert_equal "263410685", golden[0].id
  end
end
