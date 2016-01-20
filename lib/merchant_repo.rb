require 'csv'
require_relative 'merchant'

class MerchantRepository
  attr_reader :all

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(file = nil)
    content ||= CSV.open "#{file}", headers: true, header_converters: :symbol
    @all ||= content.to_a.map { |row| Merchant.new(row.to_hash) }
  end

  def find_by_id(id)
    all.detect { |merchant| merchant.id == id }
  end

  def find_by_name(name)
    all.detect { |merchant| merchant.name.downcase == name.downcase }
  end

  def find_all_by_name(descript)
    all.select { |merchant| merchant.name.downcase.include?(descript.downcase) }
  end
end
