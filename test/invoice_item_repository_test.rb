require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :ir

  def setup
    @ir = InvoiceItemRepository.new("./data/fixtures/invoice_items.csv")
  end

  def test_all_returns_array_of_invoice_items
    refute ir.all.empty?
    assert_equal InvoiceItem, ir.all[0].class
  end

  def test_find_all_by_id_returns_matching_invoice_item
    invoice_item = ir.find_by_id(1)
    assert_equal InvoiceItem, invoice_item.class
  end

  def test_find_all_by_id_returns_nil_if_no_match
    invoice_items = ir.find_by_id(11111111111111111)
    assert_equal nil, invoice_items
  end

  def test_find_all_by_item_id_returns_matches
    invoice_items = ir.find_all_by_item_id(263519844)
    refute invoice_items.empty?
  end

  def test_find_all_by_item_id_returns_empty_if_no_matches
    invoice_items = ir.find_all_by_item_id(11111111111111111)
    assert_equal [], invoice_items
  end

  def test_find_all_by_invoice_id_returns_matches
    invoice_items = ir.find_all_by_invoice_id(1)
    refute invoice_items.empty?
  end

  def test_find_all_by_invoice_id_returns_empty_if_no_matches
    invoice_items = ir.find_all_by_invoice_id(11111111111111111)
    assert_equal [], invoice_items
  end
end
