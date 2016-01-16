require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/unit'
require 'mocha/mini_test'
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

  def test_returns_top_merchants_by_invoice_count
    sa.stubs(:average_invoices_per_merchant).returns(10)
    sa.stubs(:average_invoices_per_merchant_standard_deviation).returns(5)
    top_merchants = sa.top_merchants_by_invoice_count

    refute top_merchants.empty?

    assert_equal Merchant, top_merchants[0].class
    assert_equal 1, top_merchants.count
    assert_equal 29, top_merchants[0].invoices.count
  end

  def test_returns_bottom_merchants_by_invoice_count
    sa.stubs(:average_invoices_per_merchant).returns(20)
    sa.stubs(:average_invoices_per_merchant_standard_deviation).returns(5)
    bottom_merchs = sa.bottom_merchants_by_invoice_count

    refute bottom_merchs.empty?

    assert_equal Merchant, bottom_merchs[0].class
    assert_equal 4, bottom_merchs.count
    assert_equal 7, bottom_merchs[0].invoices.count
    assert_equal 9, bottom_merchs[-1].invoices.count
  end

  def test_returns_top_days_by_invoice_count
    days = sa.top_days_by_invoice_count

    refute days.empty?
    assert_equal "Friday", days[0]
  end

  def test_returns_percentage_of_invoices_by_shipped_status
    assert_equal 30.28, sa.invoice_status(:pending)
    assert_equal 61.47, sa.invoice_status(:shipped)
    assert_equal 8.26, sa.invoice_status(:returned)
  end

end
