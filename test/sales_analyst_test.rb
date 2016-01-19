require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/unit'
# require 'mocha/mini_test'
RSpec.configure { |c| c.mock_with :mocha }
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items => "./data/fixtures/items.csv",
      :merchants => "./data/fixtures/merchants.csv",
      :invoices => "./data/fixtures/invoices.csv",
      :invoice_items => "./data/fixtures/invoice_items.csv",
      :transactions => "./data/fixtures/transactions.csv",
      :customers => "./data/fixtures/customers.csv"})
    @sa = SalesAnalyst.new(se)

  end

  def test_returns_average_price_per_merchant
    avg = sa.average_average_price_per_merchant

    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.14526E3')
  end

  def test_returns_average_items_per_merchant
    assert_equal 10.67, sa.average_items_per_merchant
  end

  def test_returns_average_items_per_merchant_standard_deviation
    assert_equal 5.92, sa.average_items_per_merchant_standard_deviation
  end

  def test_returns_merchants_with_high_item_count
    merchant_list = sa.merchants_with_high_item_count

    refute merchant_list.empty?
    assert_equal Merchant, merchant_list[0].class
    assert_equal 2, merchant_list.count
  end

  def test_returns_average_item_price_for_merchant
    avg = sa.average_item_price_for_merchant(12334112)

    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.9897E2')
  end

  def test_returns_golden_items
    golden = sa.golden_items

    refute golden.empty?
    assert_equal Item, golden[0].class
    assert_equal 263403749, golden[0].id
  end

  def test_returns_average_invoices_per_merchant
    assert_equal 12.11, sa.average_invoices_per_merchant
  end

  def test_returns_standard_deviation_of_invoices_per_merchant
    assert_equal 6.79, sa.average_invoices_per_merchant_standard_deviation
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
    assert_equal 5, bottom_merchs.count
    assert_equal 7, bottom_merchs[0].invoices.count
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

  def test_returns_total_price_of_revenue_for_given_date
    assert_equal 422243.44, sa.merchant_revenue_by_date('2012-02-26')
    assert_equal 0, sa.merchant_revenue_by_date('2020-02-26')
  end

  def test_returns_top_revenue_earners
    top_three = sa.top_revenue_earners(3)

    refute top_three.empty?
    assert_equal 3, top_three.count
    assert_equal Merchant, top_three[0].class
  end

  def test_returns_top_x_buyers
    top_three = sa.top_buyers(3)

    refute top_three.empty?
    assert_equal 3, top_three.count
    assert_equal Customer, top_three[0].class
  end

  def test_returns_all_merchants_with_pending_invoices
    pending = sa.merchants_with_pending_invoices

    assert_equal Merchant, pending[0].class
    assert_equal 85, pending.count
  end

  def test_returns_all_merchants_with_only_one_item
    sa.stubs(:merchant_item_count).returns([1, 4, 1, 4, 6, 9, 10, 5, 9])
    merchants_single_item = sa.merchants_with_only_one_item

    assert_equal Merchant, merchants_single_item[0].class
    assert_equal 2, merchants_single_item.count
  end

  def test_returns_empty_array_when_no_merchants_with_one_item
    sa.stubs(:merchant_item_count).returns([5, 4, 2, 4, 6, 9, 10, 5, 9])
    merchants_single_item = sa.merchants_with_only_one_item

    assert_equal [], merchants_single_item
  end

  def test_returns_total_revenue_for_given_merchant
    total_revenue = sa.revenue_by_merchant(12334105)

    assert_equal 139189.8, total_revenue
  end

  def test_returns_the_most_sold_item_for_a_given_merchant
    sa.stubs(:rank_by_most_items_sold).returns([263519844])
    top_item = sa.most_sold_item_for_merchant(12334105)

    assert_equal Item, top_item[0].class
  end
end
