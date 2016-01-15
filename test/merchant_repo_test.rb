require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repo'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :mr

  def setup
    @mr = MerchantRepository.new("./data/fixtures/merchants.csv")
  end

  def test_merchant_array_is_not_empty
    refute mr.all.empty?
  end

  def test_returns_nil_if_merchant_id_is_not_found
    assert_equal nil, mr.find_by_id("1233")
  end

  def test_returns_merchant_if_merchant_id_is_found
    merchant1 = mr.find_by_id("12334105")
    assert_equal "12334105", merchant1.id
  end

  def test_returns_nil_if_merchant_name_not_found
    merchant1 = mr.find_by_name('Turing')
    assert_equal nil, merchant1
  end

  def test_returns_merchant_if_merchant_name_is_found
    merchant1 = mr.find_by_name('MiniatureBikez')
    assert_equal 'MiniatureBikez', merchant1.name
  end

  def test_case_insensive_when_searching_merchant_name
    merchant1 = mr.find_by_name('MINIATUREBIKEZ')
    assert_equal 'MiniatureBikez', merchant1.name
  end

  def test_returns_empty_array_when_name_not_found
    merchant1 = mr.all_by_name("Turing")
    assert_equal [], merchant1
  end

  def test_returns_all_matches_of_merchant_with_name_fragment
    merchant1 = mr.all_by_name("m")
    assert_equal "MiniatureBikez", merchant1[0].name
  end
end
