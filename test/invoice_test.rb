require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'

class InvoiceTest < Minitest::Test
  attr_reader :invoice, :iv, :se

  def setup
    @invoice = Invoice.new({:id => '1',
                            :customer_id => '4',
                            :merchant_id => '12345569',
                            :status => "PENDING",
                            :created_at => "2001-12-13",
                            :updated_at => "2006-05-02"})
    @se = SalesEngine.from_csv({
      :items => "./data/fixtures/items.csv",
      :merchants => "./data/fixtures/merchants.csv",
      :invoices => "./data/fixtures/invoices.csv",
      :invoice_items => "./data/fixtures/invoice_items.csv",
      :transactions => "./data/fixtures/transactions.csv",
      :customers => "./data/fixtures/customers.csv"})
    @iv = se.invoices
  end

  def test_returns_invoice_id
    assert_equal 1, invoice.id
  end

  def test_returns_customer_id
    assert_equal 4, invoice.customer_id
  end

  def test_returns_merchant_id
    assert_equal 12345569, invoice.merchant_id
  end

  def test_returns_status
    assert_equal :PENDING, invoice.status
  end

  def test_returns_date_invoice_was_creates
    time = invoice.created_at

    assert_equal Time, time.class
    assert invoice.created_at.to_s.include?("2001-12-13")
  end

  def test_returns_date_invoice_was_updated
    time = invoice.updated_at

    assert_equal Time, time.class
    assert invoice.updated_at.to_s.include?("2006-05-02")
  end

  def test_tells_if_invoice_paid_in_full
    invoice = iv.find_by_id(1)

    assert invoice.is_paid_in_full?

    invoice = iv.find_by_id(9)

    refute invoice.is_paid_in_full?
  end

  def test_returns_total_dollar_amount_of_invoice
    invoice = iv.find_by_id(4)
    assert_equal 1964.05, invoice.total
  end
end
