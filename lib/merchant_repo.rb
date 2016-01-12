require 'csv'
require_relative '../lib/merchant'
require 'pry'
class MerchantRepository
  attr_reader :all, contents

  def initialize(file)
    @all = []
    @contents = CSV.open "#{file}", headers: true, header_converters: :symbol
    parse_data
  end

  def parse_data
    contents.each do |row|
      data = {:id => row[:id], :name  => row[:name],
      :created_at => row[:created_at], :updated_at =>  row[:updated_at]}
      @all << Merchant.new(data)
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
