require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :cr
  def setup
    @cr = CustomerRepository.new("./data/fixtures/customers.csv")
  end

  def test_returns_all_customers
    refute cr.all.empty?
    assert_equal Customer, cr.all[0].class
  end

  def test_returns_nil_if_no_customer_is_found
    customer = cr.find_by_id(100)

    assert_equal nil, customer
  end

  def test_returns_a_customer_by_searching_for_its_id
    customer = cr.find_by_id(1)

    assert_equal 1, customer.id
  end

  def test_returns_all_customers_with_matching_first_name
    customers = cr.find_all_by_first_name("Casimer")

    assert_equal "Casimer", customers[0].first_name
  end

  def test_returns_all_customers_with_matching_substring_fragment_last_name
    customers = cr.find_all_by_first_name("Cas")

    assert_equal "Casimer", customers[0].first_name
  end

  def test_returns_all_customers_with_matching_last_name
    customers = cr.find_all_by_last_name("Hettinger")

    assert_equal "Hettinger", customers[0].last_name
  end

  def test_returns_all_customers_with_matching_substring_fragment_of_last_name
    customers = cr.find_all_by_last_name("Het")

    assert_equal "Hettinger", customers[0].last_name
  end
end
