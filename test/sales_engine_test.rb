require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repo'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'
require 'pry'

class SalesEngineTest < Minitest::Test
  attr_reader :se, :mr, :it
  def setup
    @se = SalesEngine.new
    se.from_csv({
      :items    => './data/items.csv',
      :merchants => './data/merchants.csv'})
    @mr = se.merchants
    @it = se.items
  end

  def test_loads_data_into_repositories
    refute mr.all.empty?
    refute it.all.empty?
  end

  def test_find_merchant_id
    merchant1 = mr.find_by_id("12334105")

    assert_equal "12334105", merchant1.id
  end

  def test_find_item_id
    item = it.find_by_id("263395237")
    assert_equal "263395237", item.id
  end
end
