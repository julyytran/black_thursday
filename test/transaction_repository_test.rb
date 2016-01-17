require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test

  def setup
    @tr = TransactionRepository.new("./data/fixtures/transactions.csv")
  end
end
