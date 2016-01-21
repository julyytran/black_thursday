class Merchant

  attr_reader :data, :i_items

  def initialize(data)
    @data = data
  end

  def id
    id = data[:id]
    id.to_i
  end

  def name
    data[:name]
  end

  def created_at
    Time.parse(data[:created_at])
  end

  def updated_at
    Time.parse(data[:updated_at])
  end

  def items
    @items ||= SalesEngine.items.find_all_by_merchant_id(id)
  end

  def items_count
    items.count
  end

  def items_prices
    if items.nil?
      return 0
    else
    items_prices = items.map {|item| item.unit_price}
    end
  end

  def most_sold_item_ids
    quantities = invoice_items.map do |item_group|
      {item_group.item_id => item.quantity}
    end.reduce Hash.new, :merge

  # def revenue
  #   items_prices.reduce(&:+)
  # end
    # quantities = invoice_items.reduce({}) do |hash, invoice_item|
    #   hash[invoice_item.item_id] = 0 if hash[invoice_item.item_id].nil?
    #   hash[invoice_item.item_id] += invoice_item.quantity
    #   hash
    # end

    quant_ranking = quantities.sort_by { |k,v| v}.reverse
    max = quant_ranking[0][1]
    quant_rank = quant_ranking.to_h

    quant_counts = quant_rank.values
    item_id = quant_rank.keys

    most_sold_ids = item_id.find_all.with_index do |num, index|
      quant_counts[index] == max
    end
  end

  # def revenue
  #   invoice_items_prices.reduce(:+)
  # end

  def invoice_items_prices
    invoice_items_prices = invoice_items.map {|i_item_group| i_item_group.map(&:unit_price)}.reduce(:+)
  end

  def invoices
    @invoices ||= SalesEngine.invoices.find_all_by_merchant_id(id)
  end

  def invoices_count
    invoices.count
  end

  def invoice_items
    invoice_ids = invoices.map(&:id)
    @i_items ||= SalesEngine.invoice_items
    invoice_items = invoice_ids.map {|invoice_id| i_items.find_all_by_invoice_id(invoice_id)}
  end

  def customers
    @customers ||= invoices.map { |invoice| SalesEngine.customers.find_by_id(invoice.customer_id) }.uniq
  end
end
