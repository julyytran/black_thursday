require 'csv'
require_relative 'merchant'

class MerchantRepository

  attr_reader :all

<<<<<<< HEAD
  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file_path = nil)
    content ||= CSV.open "#{file_path}", headers: true, header_converters: :symbol
    @all = content.to_a.map { |row| Merchant.new(row.to_hash)}
  end

  def find_by_id(id)
    all.detect do |merchant|
      merchant.id == id
    end
  end.to_s
=======
  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
    @all = content.to_a.map { |row| Merchant.new(row.to_hash) }
  end

  def find_by_id(id)
    all.detect { |merchant| merchant.id == id }
  end
>>>>>>> f45f471f5439a84f0bb0a04b3148b5e8bb35dee6

  def find_by_name(name)
    all.detect { |merchant| merchant.name.downcase == name.downcase }
  end

<<<<<<< HEAD
  def find_all_by_name(description)
    all.select do |merchant|
      merchant.name.downcase.include?(description.downcase)
    end
=======
  def all_by_name(descript)
    all.select { |merchant| merchant.name.downcase.include?(descript.downcase) }
>>>>>>> f45f471f5439a84f0bb0a04b3148b5e8bb35dee6
  end
end
