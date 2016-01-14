require 'csv'
require 'bigdecimal'
require_relative 'item'

class ItemRepository

  attr_reader :all

  def initialize(file_path = nil)
    content = CSV.open "#{file_path}", headers: true, header_converters: :symbol
    @all = content.to_a.map { |row| Item.new(row.to_hash)}
  end

  def find_by_id(id)
    all.detect do |x|
      x.id == id
    end
  end

  def find_by_name(name)
    all.detect do |x|
      x.name.downcase == name.downcase
    end
  end

  def find_all_with_description(description)
    all.select do |x|
      x.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(price)
    all.select do |x|
      x.unit_price.to_i == price.to_i
    end
  end

  def find_all_by_price_in_range(range)
    all.select do |x|
      range.include?(x.unit_price.to_i)
    end
  end

  def find_all_by_merchant_id(id)
    all.select do |x|
      x.merchant_id == id
    end
  end

end
