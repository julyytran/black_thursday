require 'csv'
require 'bigdecimal'
require_relative 'item'
require 'bigdecimal'

class ItemRepository

  attr_reader :all, :file

  def initialize(file)
    @file = file
    @all= []
  end

  def load_data(file)
    contents = CSV.open "#{file}", headers: true, header_converters: :symbol

    contents.each do |row|
    @all << Item.new({:id => row[0],
      :name => row[:name],
      :description => row[:description],
      :unit_price => BigDecimal.new(row[:unit_price], 4),
      :merchant_id => row[:merchant_id],
      :created_at => row[:created_at],
      :updated_at => row[:updated_at]})
    end
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
      x.unit_price.to_i == price
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
