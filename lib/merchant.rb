class Merchant
  attr_reader :id, :name, :created_at, :updated_at


  def initialize(merchant_data)
    merchant_data.each do |k,v|
      instance_variable_set("@#{k}", v)
    end
  end
end
