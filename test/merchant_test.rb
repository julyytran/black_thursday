require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant'

class MerchantTest < Minitest::Test

  def test_returns_id_of_merchant
    m = Merchant.new({:id => "00000000"})

    assert "00000000", m.id
  end

  def test_returns_name_of_merchant
    m = Merchant.new({:name => "Turing"})

    assert_equal "Turing", m.name
  end

  def test_returns_date_created_at
    m = Merchant.new({:created_at => "2016-01-11 17:35:53 UTC" })
    time = m.created_at
    assert_equal DateTime, time.class
    assert_equal "2016-01-11T17:35:53+00:00", time.to_s
  end

  def test_returns_date_updated_at
    m = Merchant.new({:updated_at => "2016-11-11 12:35:53 UTC" })
    time = m.updated_at
    assert_equal DateTime, time.class
    assert_equal "2016-11-11T12:35:53+00:00", time.to_s
  end
end
