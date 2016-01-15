require 'csv'
require_relative 'merchant'

class MerchantRepository
  attr_reader :all

  def initialize(file_path = nil)
    content ||= CSV.open "#{file_path}", headers: true, header_converters: :symbol
    @all = content.to_a.map { |row| Merchant.new(row.to_hash)}
  end

  def find_by_id(id)
    all.detect do |merchant|
      merchant.id == id
    end
  end

  def find_by_name(name)
    all.detect do |merchant|
      merchant.name.downcase == name.downcase
    end
  end

  def all_by_name(description)
    all.select do |merchant|
      merchant.name.downcase.include?(description.downcase)
    end
  end
end
