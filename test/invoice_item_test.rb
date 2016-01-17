require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/invoice_item'

class InvoiceItemTest < Minitest::Test
  attr_reader :ii

  def setup
    @ii = InvoiceItem.new({
        :id => 6,
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => "1200",
        :created_at => Time.now,
        :updated_at => Time.now})
  end

  def test_returns_id
    assert_equal 6, ii.id
  end

  def test_returns_item_id
    assert_equal 7, ii.item_id
  end

  def test_returns_invoice_id
    assert_equal 8, ii.invoice_id
  end

  def test_returns_quantity
    assert_equal 1, ii.quantity
  end

  def test_returns_unit_price
    assert_equal BigDecimal, ii.unit_price.class
  end

  def returns_time_created_at
    assert_equal Time, ii.created_at.class
  end

  def returns_time_updated_at
    assert_equal Time, ii.created_at.class
  end

end
