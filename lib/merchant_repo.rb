require 'csv'
require_relative '../lib/merchant'
require 'pry'
class MerchantRepository
  attr_reader :all

  def initialize
    @all = []
  end

  def load_data(file)
    contents = CSV.open "#{file}", headers: true, header_converters: :symbol

    contents.each do |row|
      merchant_data = {:id => row[:id], :name  => row[:name],
      :created_at => row[:created_at], :updated_at =>  row[:updated_at]}
      @all << Merchant.new(merchant_data)
    end
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

  def all_by_name(name)
      all.select do |merchant|
      merchant.name.downcase == name.downcase
    end
  end
end
