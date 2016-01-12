class Item

  attr_reader :contents, :id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
  
end
