require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/item'

class ItemTest < Minitest::Test

  attr_reader :item

  def setup
    @item = Item.new({
                :id => 1,
                :merchant_id => 1,
                :name => "Pencil",
                :description => "You can use it to write things",
                :unit_price => 1200, #BigDecimal.new(10.99,4),
                :created_at => DateTime.strptime("2016-01-11 20:59:20 UTC", "%F %T"),
                :updated_at => DateTime.strptime("2009-12-09 12:08:04 UTC", "%F %T")
              })
  end

  def test_id
    assert_equal 1, item.id
  end

  def test_name
    assert_equal "Pencil", item.name
  end

  def test_description
    assert_equal "You can use it to write things", item.description
  end

  def test_unit_price
    assert_equal 1200, item.unit_price
  end

  def test_created_at
    time = item.created_at
    assert_equal DateTime, time.class
    assert_equal "2016-01-11T20:59:20+00:00", time.to_s
  end

  def test_updated_at
    time = item.updated_at
    assert_equal DateTime, time.class
    assert_equal "2009-12-09T12:08:04+00:00", time.to_s
  end

end
