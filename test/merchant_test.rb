require 'minitest/autorun'
require 'minitest/pride'
require_relative './lib/merchant'

class MerchantTest < Minttest::Test

  def test_returns_integer_id_of_merchant
    m = Merchant.new({:name => ""})
  end

  def test_returns_name_of_merchant
    m = Merchant.new({:name => ""})
  end 
end
