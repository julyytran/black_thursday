require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test

  attr_reader :mr, :ir

  def setup
    @se = SalesEngine.from_csv({
      :items    => './data/fixtures/items.csv',
      :merchants => './data/fixtures/merchants.csv'})
    @mr = @se.merchants
    @ir = @se.items
  end

  def test_loads_data_into_repositories
    refute mr.all.empty?
    refute ir.all.empty?
  end

  def test_returns_merchant_id
    merchant_1 = mr.find_by_id("12334105")
    assert_equal "12334105", merchant_1.id
  end

  def test_returns_item_id
    item_1 = ir.find_by_id("263395237")
    assert_equal "263395237", item_1.id
  end

  def test_returns_all_items_that_match_a_merchants_id
    merchant = mr.find_by_id("12334105")
    merchant_items = merchant.items
    assert_equal 3, merchant_items.count
    end

    def test_returns_merchant_that_match_item_id
      item = ir.find_by_id("263395237")
      assert_equal '12334141', item.merchant.id
    end

  end
