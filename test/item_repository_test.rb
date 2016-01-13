require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item_repository'

class ItemRepositoryTest < Minitest::Test

  attr_reader :ir

  def setup
    @ir = ItemRepository.new("./data/items.csv")
  end

  def test_item_repo_is_not_empty
    refute ir.all.empty?
  end

  def test_returns_item_id
    item = ir.find_by_id("263395237")
    assert_equal "263395237", item[:id]
  end

  def test_returns_nil_if_item_id_not_found
    item = ir.find_by_id("0000000")
    assert_equal nil, item
  end

  def test_returns_name_of_item_name
    item = ir.find_by_name("510+ RealPush Icon Set")
    assert_equal "510+ RealPush Icon Set", item[:name]
  end

  def test_case_insensitive_when_searching_item_name
    item = ir.find_by_name("510+ realpush icon set")
    assert_equal "510+ RealPush Icon Set", item[:name]
  end

  def test_returns_nil_if_name_not_found
    item = ir.find_by_name("Super cool awesome thing")
    assert_equal nil, item
  end

  def test_returns_description_of_item
    items = ir.find_all_with_description("glitter")
    refute items.empty?
  end

  def test_case_insensitive_when_searching_item_description
    items = ir.find_all_with_description("GLITTER")
    refute items.empty?
  end

  def test_returns_empty_array_when_description_not_found
    items = ir.find_all_with_description("npauearcsa")
    assert_equal [], items
  end

  def test_returns_unit_price_of_item
    items = ir.find_all_by_price(1300)
    refute items.empty?
  end

  def test_find_all_by_price_not_found
    items = ir.find_all_by_price(0)
    assert_equal [], items
  end

  def test_returns_items_in_an_array_within_unit_price_range
    items = ir.find_all_by_price_in_range(700..4000)
    refute items.empty?
  end

  def test_returns_an_empty_array_when_unit_price_range_not_found
    items = ir.find_all_by_price_in_range(-1..0)
    assert items.empty?
  end

  def test_returns_item_with_matching_merchant_id
    items = ir.find_all_by_merchant_id("12334185")
    refute items.empty?
  end

  def test_returns_empty_array_when_merchant_id_not_found
    items = ir.find_all_by_merchant_id("0")
    assert [], items
  end

end
