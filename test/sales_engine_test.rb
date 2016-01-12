require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repo'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test

  def test_loads_data_into_repositories
    se = SalesEngine.from_csv({
      :items    => './data/items.csv',
      :merchant => './data/merchants.csv'}

  end
end
