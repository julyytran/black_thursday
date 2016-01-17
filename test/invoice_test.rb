require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/invoice'

class InvoiceTest < Minitest::Test

  attr_reader :invoice

  def setup
    @invoice = Invoice.new({:id => '1',
                            :customer_id => '4',
                            :merchant_id => '12345569',
                            :status => "PENDING",
                            :created_at => "2001-12-13",
                            :updated_at => "2006-05-02"})
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
    assert_equal 'PENDING', invoice.status
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

end
