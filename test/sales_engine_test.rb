require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require 'pry'

class SalesEngineTest < Minitest::Test

  attr_reader :mr, :ir, :iv, :ii, :trans, :cust

  def setup
    @se = SalesEngine.from_csv({
      :items => "./data/fixtures/items.csv",
      :merchants => "./data/fixtures/merchants.csv",
      :invoices => "./data/fixtures/invoices.csv",
      :invoice_items => "./data/fixtures/invoice_items.csv",
      :transactions => "./data/fixtures/transactions.csv",
      :customers => "./data/fixtures/customers.csv"})
    @mr = @se.merchants
    @ir = @se.items
    @iv = @se.invoices
    @ii = @se.invoice_items
    @trans = @se.transactions
    @cust = @se.customers
  end

  def test_loads_data_into_repositories
    refute mr.all.empty?
    assert_equal MerchantRepository, mr.class

    refute ir.all.empty?
    assert_equal ItemRepository, ir.class

    refute iv.all.empty?
    assert_equal InvoiceRepository, iv.class

    refute ii.all.empty?
    assert_equal InvoiceItemRepository, ii.class

    refute trans.all.empty?
    assert_equal TransactionRepository, trans.class

    refute cust.all.empty?
    assert_equal CustomerRepository, cust.class
  end

  def test_returns_merchant_id
    merchant_1 = mr.find_by_id(12334105)

    assert_equal 12334105, merchant_1.id
  end

  def test_returns_item_id
    item_1 = ir.find_by_id(263395237)

    assert_equal 263395237, item_1.id
  end

  def test_returns_all_items_that_match_a_merchants_id
    merchant = mr.find_by_id(12334105)
    merchant_items = merchant.items

    assert_equal 4, merchant_items.count
  end

  def test_returns_merchant_that_match_item_id
    item = ir.find_by_id(263395237)
    merchant = item.merchant

    assert_equal 12334105, merchant.id
  end

  def test_returns_invoice_that_match_invoice_id
    invoice = iv.find_by_id(1)

    assert_equal 1, invoice.id
  end

  def test_returns_all_invoices_that_match_merchant_id
    merchant = mr.find_by_id(12334112)
    merchant_invoices = merchant.invoices

    assert_equal 14, merchant_invoices.count
    assert_equal 12, merchant_invoices[0].id
  end

  def test_returns_merchant_that_match_invoice_merchant_id
    invoice = iv.find_by_id(1)
    merchant = invoice.merchant

    assert_equal 12334105, merchant.id
  end

  def test_returns_all_items_that_match_invoice_id
    invoice = iv.find_by_id(1)
    result = invoice.items

    assert_equal 1, result[0].invoice_id
    assert_equal 263519844, result[0].item_id
    assert_equal 263454779, result[1].item_id
    assert_equal 263451719, result[2].item_id
  end

  def test_returns_all_transactions_that_match_invoice_id
    invoice = iv.find_by_id(1)
    result = invoice.transactions

    assert_equal 1, result[0].invoice_id
    assert_equal 1, result[0].id
    assert_equal "4068631943231473", result[0].credit_card_number
  end

  def test_returns_customer_the_match_invoice_id
    invoice = iv.find_by_id(1)
    result = invoice.customer

    assert_equal "Joey", result.first_name
    assert_equal "Ondricka", result.last_name
  end
end
