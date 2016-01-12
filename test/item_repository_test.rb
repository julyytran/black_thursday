require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item_repository'

class ItemRepositoryTest < Minitest::Test

  attr_reader :ir

  def setup
    @ir = ItemRepository.new
    ir.load_data("./data/items.csv")
  end

  def test_all
    refute ir.all.empty?
  end

  def test_find_by_id_found
    item = ir.find_by_id("263395237")
    assert_equal "263395237", item.id
  end

  def test_find_by_id_not_found
    item = ir.find_by_id("0000000")
    assert_equal nil, item
  end

  def test_find_by_name_found
    item = ir.find_by_name("510+ RealPush Icon Set")
    assert_equal "510+ RealPush Icon Set", item.name
  end

  def test_find_by_name_found_case_insensitive
    item = ir.find_by_name("510+ realpush icon set")
    assert_equal "510+ RealPush Icon Set", item.name
  end

  def test_find_by_name_not_found
    item = ir.find_by_name("Super cool awesome thing")
    assert_equal nil, item
  end

  def test_find_all_with_description_found
    items = ir.find_all_with_description("glitter")
    refute items.empty?
  end

  def test_find_all_with_description_found_case_insensitive
    items = ir.find_all_with_description("GLITTER")
    refute items.empty?
  end

  def test_find_all_with_description_not_found
    items = ir.find_all_with_description("npauearcsa")
    assert items.empty?
  end

  def test_find_all_by_price_found
    items = ir.find_all_by_price(1300)
    refute items.empty?
  end

  def test_find_all_by_price_not_found
    items = ir.find_all_by_price(0)
    assert items.empty?
  end

  def test_find_all_by_price_in_range_found
    items = ir.find_all_by_price_in_range(700..4000)
    refute items.empty?
  end

  def test_find_all_by_price_in_range_not_found
    items = ir.find_all_by_price_in_range(-1..0)
    assert items.empty?
  end

  def test_find_all_by_merchant_id_found
    items = ir.find_all_by_merchant_id("12334185")
    refute items.empty?
  end

  def test_find_all_by_merchant_id_not_found
    items = ir.find_all_by_merchant_id("0")
    assert items.empty?
  end

end
