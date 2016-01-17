require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/customer'

class CustomerTest < Minitest::Test
  attr_reader :customer

  def setup
    @customer = Customer.new({:id => "1", :first_name => "Sylvester", :last_name => "Nader", :created_at => "2012-03-27 14:54:10 UTC", :updated_at => "2012-03-27 14:54:10 UTC"})
  end

  def test_returns_customer_id
    assert_equal 1, customer.id
  end

  def test_returns_customers_first_name
    assert_equal "Sylvester", customer.first_name
  end

  def test_returns_customers_last_name
      assert_equal "Nader", customer.last_name
  end

  def test_returns_date_customer_was_created
    skip

  end
end
