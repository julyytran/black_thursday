require 'csv'
require_relative '../lib/merchant'

class MerchantRepository
  attr_reader :all

  def initialize
    @all = []
  end

  def parse_data(file_path)
    contents = CSV.open "#{file_path}", headers: true, header_converters: :symbol

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

  def all_by_name(description)
    all.select do |merchant|
      merchant.name.downcase.include?(description.downcase)
    end
  end
end
