require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test

  def test_loads_data_into_repositories
    se = SalesEngine.from_csv({
      :items    => './data/items.csv',
      :merchants => './data/merchants.csv'})
    mr = se.merchants
    ir = se.items
    refute mr.all.empty?
    refute ir.all.empty?
  end

  def test_returns_merchant_id
    se = SalesEngine.from_csv({
      :items    => './data/items.csv',
      :merchants => './data/merchants.csv'})
    mr = se.merchants
    merchant_1 = mr.find_by_id("12334105")

    assert_equal "12334105", merchant_1.id
  end

  def test_returns_item_id
    se = SalesEngine.from_csv({
      :items    => './data/items.csv',
      :merchants => './data/merchants.csv'})
    ir = se.items
    item_1 = ir.find_by_id("263395237")

    assert_equal "263395237", item_1.id
  end

  def test_returns_all_items_that_match_a_merchants_id
    se = SalesEngine.from_csv({
      :items    => './data/items.csv',
      :merchants => './data/merchants.csv'})
    merchant = se.merchants.find_by_id("12334105")
    merchant_items = merchant.items
    assert_equal 3, merchant_items.count
    end

    def test_returns_merchant_that_match_item_id
      se = SalesEngine.from_csv({
        :items    => './data/items.csv',
        :merchants => './data/merchants.csv'})
      item = se.items.find_by_id("263395237")

      assert_equal '12334141', item.merchant.id
    end

  end
