require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test

  attr_reader :ir

  def setup
    @ir = InvoiceRepository.new("./data/fixtures/invoices.csv")
  end

  def test_returns_all_invoice_items
    refute ir.all.empty?

    assert_equal Invoice, ir.all[0].class
  end

  def test_returns_item_id
    invoice = ir.find_by_id(8)
    invoice_1 = ir.find_by_id(20)

    assert_equal 8, invoice.id
    assert_equal 20, invoice_1.id
  end

  def test_returns_nil_when_no_invoices_with_matching_id
    invoice = ir.find_by_id("0")
    assert_equal nil, invoice
  end

  def test_returns_all_customers_with_mathching_customer_id
    invoice = ir.find_all_by_customer_id(1)

    assert_equal 1, invoice[0].customer_id
    assert_equal 1, invoice[2].customer_id
    assert_equal 1, invoice[1].customer_id
    assert_equal 1, invoice[3].customer_id
    assert_equal 1, invoice[4].customer_id
  end

  def test_returns_all_invoices_with_matching_merchant_id
    invoice = ir.find_all_by_merchant_id(12334112)

    assert_equal 12334112, invoice[0].merchant_id
  end

  def test_returns_empty_array_if_no_invoices_match_merchant_id
    invoice = ir.find_all_by_merchant_id("00000")

    assert_equal [], invoice
  end

  def test_returns_status_of_invoice
    invoices = ir.find_all_by_status("pending")
    invoice_1 = ir.find_all_by_status("shipped")

    assert_equal :pending, invoices[0].status
    assert_equal :shipped, invoice_1[1].status
  end

  def test_returns_empty_array_if_no_invoices_match_status
    invoice = ir.find_all_by_status("totallylost")

    assert_equal [], invoice
  end
end
