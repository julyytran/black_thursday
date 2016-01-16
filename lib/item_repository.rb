require 'csv'
require 'bigdecimal'
require_relative 'item'

class ItemRepository

  attr_reader :all

<<<<<<< HEAD
  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file_path = nil)
    content = CSV.open "#{file_path}", headers: true, header_converters: :symbol
    @all = content.to_a.map { |row| Item.new(row.to_hash)}
  end

  def find_by_id(id)
    all.detect do |x|
      x.id == id
    end
  end.to_s
=======
  def initialize(file = nil)
    content = CSV.open "#{file}", headers: true, header_converters: :symbol
    @all = content.to_a.map { |row| Item.new(row.to_hash) }
  end

  def find_by_id(id)
    all.detect { |x| x.id == id }
  end
>>>>>>> f45f471f5439a84f0bb0a04b3148b5e8bb35dee6

  def find_by_name(name)
    all.detect { |x| x.name.downcase == name.downcase }
  end

  def find_all_with_description(description)
    all.select { |x| x.description.downcase.include?(description.downcase) }
  end

  def find_all_by_price(price)
    all.select { |x| x.unit_price.to_i == price.to_i }
  end

  def find_all_by_price_in_range(range)
    all.select { |x| range.include?(x.unit_price.to_i) }
  end

  def find_all_by_merchant_id(id)
<<<<<<< HEAD
    all.select do |x|
      x.merchant_id == id
    end
  end.to_i
=======
    all.select { |x| x.merchant_id == id }
  end

>>>>>>> f45f471f5439a84f0bb0a04b3148b5e8bb35dee6
end
