require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repo'

class MerchantRepositoryTest < Minitest::Test

  def test_merchant_array_is_not_empty
    mr = MerchantRepository.new("./data/merchants.csv")

    refute mr.all.empty?
  end

  def test_returns_nil_if_merchant_id_is_not_found
    mr = MerchantRepository.new("./data/merchants.csv")

    assert_equal nil, mr.find_by_id("1233")
  end

  def test_returns_merchant_if_merchant_id_is_found
    mr = MerchantRepository.new("./data/merchants.csv")
    merchant1 = mr.find_by_id("12334105")

    assert_equal "12334105", merchant1.id
  end

  def test_returns_nil_if_merchant_name_not_found
    mr = MerchantRepository.new("./data/merchants.csv")
    merchant1 = mr.find_by_name('Turing')

    assert_equal nil, merchant1
  end

  def test_returns_merchant_if_merchant_name_is_found
    mr = MerchantRepository.new("./data/merchants.csv")
    merchant1 = mr.find_by_name('MiniatureBikez')

    assert_equal 'MiniatureBikez', merchant1.name
  end

  def test_case_insensive_when_searching_merchant_name
    mr = MerchantRepository.new("./data/merchants.csv")
    merchant1 = mr.find_by_name('MINIATUREBIKEZ')

    assert_equal 'MiniatureBikez', merchant1.name
  end

  def test_returns_empty_array_when_name_not_found
    mr = MerchantRepository.new("./data/merchants.csv")
    merchant1 = mr.all_by_name("Turing")

    assert_equal [], merchant1
  end

  def test_returns_all_matches_of_merchant_with_name_fragment
    mr = MerchantRepository.new("./data/merchants.csv")
    merchant1 = mr.all_by_name("m")

    assert_equal "MiniatureBikez", merchant1[0].name
  end
end
