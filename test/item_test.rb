require 'minitest/autorun'
require 'minitest/pride'
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
                :created_at => "2016-01-11 20:59:20 UTC", #Time instance
                :updated_at => "2009-12-09 12:08:04 UTC" #Time instance
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
    assert_equal "2016-01-11 20:59:20 UTC", item.created_at
  end

  def test_updated_at
    assert_equal "2009-12-09 12:08:04 UTC", item.updated_at
  end

end
