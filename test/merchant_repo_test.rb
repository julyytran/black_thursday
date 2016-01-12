require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repo'

class MerchantRepositoryTest < Minitest::Test



  def test_merchant_array_is_not_empty
    mr = MerchantRepository.new
    mr.all

    assert mr.all.empty?

    mr.load_data("./data/merchants.csv")

    refute mr.all.empty?
  end

  def test_merchant_array_has_merchants
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")

    assert_equal 475, mr.all.count
  end

  def test_returns_nil_if_merchant_id_is_not_found
    mr = MerchantRepository.new
    mr.load_data("./data/merchants.csv")
    assert_equal nil, mr.find_by_id("1233")

  end

  def test_returns_merchant_if_merchant_id_is_found
    skip
    mr = MerchantRepository.new

  end

  def test_returns_nil__if_merchant_name_not_found
    skip
    mr = MerchantRepository.new

  end

  def test_returns_merchant_if_merchant_name_is_found
    skip
    mr = MerchantRepository.new

  end

  def test_returns_empty_array
    skip
    mr = MerchantRepository.new

  end

  def test_returns_array_of_all_merchants
    skip
    mr = MerchantRepository.new

  end
end
