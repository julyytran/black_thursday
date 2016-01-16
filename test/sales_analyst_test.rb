require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items    => './data/items.csv',
      :merchants => './data/merchants.csv',
      :invoices => './data/invoices.csv'})
    @sa = SalesAnalyst.new(se)
  end

  def test_returns_average_items_per_merchant
    assert_equal 2.88, sa.average_items_per_merchant
  end

  def test_returns_average_items_per_merchant_standard_deviation
    assert_equal 3.26, sa.average_items_per_merchant_standard_deviation
  end

  def test_returns_merchants_with_high_item_count
    merchant_list = sa.merchants_with_high_item_count

    refute merchant_list.empty?
    assert_equal Merchant, merchant_list[0].class
  end

  def test_returns_average_item_price_for_merchant
    avg = sa.average_item_price_for_merchant("12334195")

    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.48335E5')
  end

  def test_returns_average_price_per_merchant
    avg = sa.average_average_price_per_merchant
<<<<<<< HEAD
    
=======

>>>>>>> f45f471f5439a84f0bb0a04b3148b5e8bb35dee6
    assert_equal BigDecimal, avg.class
    assert avg.inspect.include?('0.3502946974 9513246335 7980673684 2105263157 9E5')
  end

  def test_returns_golden_items
    golden = sa.golden_items

    refute golden.empty?
    assert_equal Item, golden[0].class
    assert_equal "263410685", golden[0].id
  end

  def test_returns_average_invoices_per_merchant
    assert_equal 10.49, sa.average_invoices_per_merchant
  end

  def test_returns_standard_deviation_of_invoices_per_merchant
    assert_equal 8.3, sa.average_invoices_per_merchant_standard_deviation
  end

end
