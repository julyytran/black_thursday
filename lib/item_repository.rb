require 'csv'
require 'bigdecimal'
require_relative 'item'

class ItemRepository
  attr_reader :all

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
    @all ||= content.to_a.map { |row| Item.new(row.to_hash) }
  end

  def find_by_id(id)
    all.detect { |x| x.id == id }
  end

  def find_by_name(name)
    all.detect { |x| x.name.downcase == name.downcase }
  end

  def find_all_with_description(description)
    all.select { |x| x.description.downcase.include?(description.downcase) }
  end

  def find_all_by_price(price)
    all.select { |x| x.unit_price == price }
  end

  def find_all_by_price_in_range(range)
    all.select { |x| range.include?(x.unit_price) }
  end

  def find_all_by_merchant_id(id)
    all.select { |x| x.merchant_id == id }
  end

  def all_item_prices
    all_item_prices ||= all.map { |item| item.unit_price }
  end

  def avg_item_price
    avg_item_price ||= all_item_prices.reduce do |sum, num|
      (sum + num)
    end/(all_item_prices.count)
  end
end
