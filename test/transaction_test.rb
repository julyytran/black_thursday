require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :transaction

  def setup
    @transaction = Transaction.new({:id => "1", :invoice_id => "1234", :credit_card_number => "4068631943231473", :result => "success", :created_at => "2012-03-27 14:54:10 UTC", :updated_at => "2012-03-27 14:54:10 UTC"})
  end

  def test_returns_transaction_id
    assert_equal 1, transaction.id
  end

  def test_returns_transaction_invoice_id
    assert_equal 1234, transaction.invoice_id
  end

  def test_returns_transaction_credit_card_number
    assert_equal "4068631943231473", transaction.credit_card_number
  end

  def test_returns_transaction_result
    assert_equal 'success', transaction.result
  end

  def test_returns_the_date_the_transaction_was_created
    assert_equal "2012-03-27 14:54:10 UTC", transaction.created_at.to_s
  end

  def test_returns_the_date_the_transaction_was_updated
    assert_equal "2012-03-27 14:54:10 UTC", transaction.created_at.to_s
  end
end
