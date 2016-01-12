class SalesEngine

  def initialize
    @merchant = MerchantRepository.new(file)
    @item = ItemRepository.new(file)
  end
  
  def self.from_csv({:items => file, :merchants => file})
    item(file).load_data
    merchant(file).load_data
  end
end
