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

  def test_returns_nil_if_no_customer_id_is_found
    customer = cr.find_by_id(100)

    assert_equal nil, customer
  end

  def test_returns_a_customer_with_matching_id
    customer = cr.find_by_id(1)

    assert_equal 1, customer.id
  end

  def test_returns_all_customers_with_matching_first_name
    customers = cr.find_all_by_first_name("Casimer")

    assert_equal "Casimer", customers[0].first_name
  end

  def test_returns_empty_array_if_customers_first_name_not_found
    customers_2 = cr.find_all_by_first_name("Mcdonalds")

    assert_equal [], customers_2
  end

  def test_returns_all_customers_with_matching_fragment_first_name
    customers = cr.find_all_by_first_name("Cas")

    assert_equal "Casimer", customers[0].first_name
  end

  def test_returns_empty_array_if_customers_last_name_not_found
    customers_2 = cr.find_all_by_last_name("Mcdzdfg")

    assert_equal [], customers_2
  end

  def test_returns_all_customers_with_matching_last_name
    customers = cr.find_all_by_last_name("Hettinger")

    assert_equal "Hettinger", customers[0].last_name
  end

  def test_returns_all_customers_with_matching_fragment_of_last_name
    customers = cr.find_all_by_last_name("Het")

    assert_equal "Hettinger", customers[0].last_name
  end
end
