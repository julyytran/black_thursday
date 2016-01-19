require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test
  attr_reader :tr

  def setup
    @tr = TransactionRepository.new("./data/fixtures/transactions.csv")
  end

  def test_returns_all_transactions
    refute tr.all.empty?
    assert_equal Transaction, tr.all[0].class
  end

  def test_returns_transaction_id
    transaction = tr.find_by_id(1)

    assert_equal 1, transaction.id
  end

  def test_returns_nil_if_transaction_id_not_found
    transaction = tr.find_by_id(1000000)

    assert_equal nil, transaction
  end

  def test_returns_all_invoices_that_match_invoice_id
    transaction = tr.find_all_by_invoice_id(4)

    assert_equal 4, transaction[0].id
  end

  def test_returns_empty_array_if_invoice_id_not_found
    invoices = tr.find_all_by_invoice_id(11111111111111)

    assert_equal [], invoices
  end

  def test_returns_all_transactions_with_matching_credit_card_number
    transaction = tr.find_all_by_credit_card_number(4068631943231473)

    assert_equal 4068631943231473, transaction[0].credit_card_number
  end

  def test_returns_empty_array_if_no_transactions_match_cc_number
    transaction = tr.find_all_by_credit_card_number("11111111111111")

    assert_equal [], transaction
  end

  def test_returns_all_transactions_with_matching_results
      transaction = tr.find_all_by_result("success")

      assert_equal "success", transaction[0].result
      assert_equal "success", transaction[1].result
      assert_equal "success", transaction[2].result
      assert_equal "success", transaction[3].result
  end

  def test_returns_empty_array_if_no_transactions_match_results
    transaction = tr.find_all_by_result("foreverlost")

    assert_equal [], transaction
  end
end
