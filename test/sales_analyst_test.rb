require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/unit'
require 'mocha/mini_test'
# RSpec.configure { |c| c.mock_with :mocha }
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})
    @sa = SalesAnalyst.new(se)
  end

  def test_returns_average_price_per_merchant
    avg = sa.average_average_price_per_merchant

    assert_equal BigDecimal, avg.class
    assert avg.inspect
  end

  def test_returns_average_items_per_merchant
    assert_equal 2.87, sa.average_items_per_merchant
  end

  def test_returns_average_items_per_merchant_standard_deviation
    assert_equal 3.26, sa.average_items_per_merchant_standard_deviation
  end

  def test_returns_merchants_with_high_item_count
    merchant_list = sa.merchants_with_high_item_count

    refute merchant_list.empty?
    assert_equal Merchant, merchant_list[0].class
    assert_equal 52, merchant_list.count
  end

  def test_returns_average_item_price_for_merchant
    avg = sa.average_item_price_for_merchant(12334112)

    assert_equal BigDecimal, avg.class
    assert_equal 15.0,  avg.to_f
  end

  def test_returns_golden_items
    golden = sa.golden_items

    refute golden.empty?
    assert_equal Item, golden[0].class
    assert_equal 263410685, golden[0].id
  end

  def test_returns_average_invoices_per_merchant
    assert_equal 10.47, sa.average_invoices_per_merchant
  end

  def test_returns_standard_deviation_of_invoices_per_merchant
    assert_equal 3.32, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_returns_top_merchants_by_invoice_count
    sa.stubs(:average_invoices_per_merchant).returns(10)
    sa.stubs(:average_invoices_per_merchant_standard_deviation).returns(5)
    top_merchants = sa.top_merchants_by_invoice_count

    refute top_merchants.empty?
    assert_equal Merchant, top_merchants[0].class
    assert_equal 2, top_merchants.count
    assert_equal 21, top_merchants[0].invoices.count
  end

  def test_returns_bottom_merchants_by_invoice_count
    sa.stubs(:average_invoices_per_merchant).returns(20)
    sa.stubs(:average_invoices_per_merchant_standard_deviation).returns(5)
    bottom_merchs = sa.bottom_merchants_by_invoice_count

    refute bottom_merchs.empty?
    assert_equal Merchant, bottom_merchs[0].class
    assert_equal 183, bottom_merchs.count
    assert_equal 7, bottom_merchs[0].invoices.count
  end

  def test_returns_top_days_by_invoice_count
    days = sa.top_days_by_invoice_count

    refute days.empty?
    assert_equal "Wednesday", days[0]
  end

  def test_returns_percentage_of_invoices_by_shipped_status
    assert_equal 29.55, sa.invoice_status(:pending)
    assert_equal 56.95, sa.invoice_status(:shipped)
    assert_equal 13.5, sa.invoice_status(:returned)
  end

  def test_returns_total_price_of_revenue_for_given_date
    revenue = sa.total_revenue_by_date('2012-02-26')
    revenue_1 = sa.total_revenue_by_date('2020-02-26')

    assert_equal BigDecimal, revenue.class
    assert_equal 30195.42, revenue.to_f

  end

  def test_returns_all_merchants_with_pending_invoices
    pending = sa.merchants_with_pending_invoices

    assert_equal Merchant, pending[0].class
    assert_equal 467, pending.count
  end

  def test_returns_merchants_with_only_one_item
    merchants = sa.merchants_with_only_one_item

    refute merchants.empty?
    assert_equal 243, merchants.count
    assert_equal Merchant, merchants[0].class
    assert_equal 1, merchants[0].items_count
  end

  def test_returns_merchants_with_only_one_item_registered_in_specific_month
    merchants = sa.merchants_with_only_one_item_registered_in_month("July")

    refute merchants.empty?
    assert_equal 18, merchants.count
    assert_equal Merchant, merchants[0].class
    assert_equal 1, merchants[0].items_count
  end

  def test_returns_revenue_by_merchant_for_given_merchant
    revenue = sa.revenue_by_merchant(12334112)

    assert_equal BigDecimal, revenue.class
  end

  def test_returns_most_sold_item_for_given_merchant
    item = sa.most_sold_item_for_merchant(12334112)

    assert_equal Item, item[0].class
    assert_equal 1, item.count
  end

  def test_returns_best_item_for_given_merchant
    item = sa.best_item_for_merchant(12334115)

    assert_equal 263454779, item.id
  end
end
