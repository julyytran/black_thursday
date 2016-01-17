require 'csv'
require_relative 'customer'

class CustomerRepository
  attr_reader :all

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
    @all = content.map { |row| Customer.new(row.to_h) }
  end

  def find_by_id(id)
    all.detect { |customer| customer.id == id }
  end

  def find_all_by_first_name(first)
    all.select { |customer| customer.first_name.include?(first) }
  end

  def find_all_by_last_name(last)
    all.select { |customer| customer.last_name.include?(last) }
  end
end
