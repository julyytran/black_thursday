require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/item'

class ItemTest < Minitest::Test
  attr_reader :item

  def setup
    @item = Item.new({
                :id => 1,
                :merchant_id => 1,
                :name => "Pencil",
                :description => "You can use it to write things",
                :unit_price => "1200",
                :created_at => "2016-01-11 20:59:20 UTC",
                :updated_at => "2009-12-09 12:08:04 UTC",})
  end

  def test_returns_item_id
    assert_equal 1, item.id
  end

  def test_returns_item_name
    assert_equal "Pencil", item.name
  end

  def test_returns_merchant_id
    assert_equal 1, item.merchant_id
  end

  def test_returns_description_of_item
    assert_equal "You can use it to write things", item.description
  end

  def test_returns_unit_price_of_item
    price = item.unit_price
    assert_equal BigDecimal, price.class
    assert price.inspect.include?("0.12E4")
  end

  def test_returns_when_item_was_created
    time = item.created_at
    assert_equal DateTime, time.class
    assert_equal "2016-01-11T20:59:20+00:00", time.to_s
  end

  def test_returns_when_item_was_updated
    time = item.updated_at
    assert_equal DateTime, time.class
    assert_equal "2009-12-09T12:08:04+00:00", time.to_s
  end
end
