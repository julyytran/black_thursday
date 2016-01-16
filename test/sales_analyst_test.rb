require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items    => './data/fixtures/items.csv',
      :merchants => './data/fixtures/merchants.csv',
      :invoices => './data/fixtures/invoices.csv'})
    @sa = SalesAnalyst.new(se)
  end

  def test_returns_average_items_per_merchant
    assert_equal 10.67, sa.average_items_per_merchant
  end

  def test_returns_average_items_per_merchant_standard_deviation
    assert_equal 5.98, sa.average_items_per_merchant_standard_deviation
  end

  def test_returns_merchants_with_high_item_count
    merchant_list = sa.merchants_with_high_item_count

    refute merchant_list.empty?
    assert_equal Merchant, merchant_list[0].class
  end

  def test_returns_average_item_price_for_merchant
    avg = sa.average_item_price_for_merchant("12334112")

    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.9897375E4')
  end

  def test_returns_average_price_per_merchant
    avg = sa.average_average_price_per_merchant

    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.1442774785 3725794902 2655555555 5555555555 6E5')
  end

  def test_returns_golden_items
    golden = sa.golden_items

    refute golden.empty?
    assert_equal Item, golden[0].class
    assert_equal "263403749", golden[0].id
  end

  def test_returns_average_invoices_per_merchant
    assert_equal 12.11, sa.average_invoices_per_merchant
  end

  def test_returns_standard_deviation_of_invoices_per_merchant
    assert_equal 6.96, sa.average_invoices_per_merchant_standard_deviation
  end

end
