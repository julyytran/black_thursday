require 'csv'
require_relative '../lib/merchant'
class MerchantRepository
  attr_reader :all

  def initialize
    @all = []
  end

  def load_data(file)
    data_file = CSV.open "#{file}", headers: true, header_converters: :symbol
    data_file.each do |row|
      merchant_data = {:id => row[:id],
          :merchant_name => row[:name],
          :created => row[:created_at],
          :updated => row[:updated_at]}
      @all << Merchant.new(merchant_data)
    end
  end


  def find_by_id(id)
    @all.each do |merchant|
      if merchant.id != id
        nil
      else
        merchant.id == id
        merchant
      end
    end
  end
end

# mr = MerchantRepository.new
# mr.load_data
# puts mr.all
# binding.pry
