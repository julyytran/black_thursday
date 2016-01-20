class Invoice
  attr_reader :data, :item_repo, :item_ids, :paid_invoices_ids

  def initialize(data)
    @data = data
  end

  def id
    data[:id].to_s.to_i
  end

  def customer_id
    data[:customer_id].to_s.to_i
  end

  def merchant_id
    data[:merchant_id].to_s.to_i
  end

  def status
    data[:status].to_sym
  end

  def created_at
    Time.parse(data[:created_at])
  end

  def updated_at
    Time.parse(data[:updated_at])
  end

  def merchant
    @merchant ||= SalesEngine.merchants.find_by_id(merchant_id)
  end

  def items
    @item_ids ||= SalesEngine.invoice_items.find_all_by_invoice_id(id).map { |invoice_item| invoice_item.item_id}
    @item_repo ||= SalesEngine.items
    item_ids.map { |item_id| item_repo.find_by_id(item_id) }
  end

  def transactions
    @transactions ||= SalesEngine.transactions.find_all_by_invoice_id(id)
  end

  def customer
    @customer ||= SalesEngine.customers.find_by_id(customer_id)
  end

  def is_paid_in_full?
    @paid_invoices_ids ||= SalesEngine.transactions.successful_transactions.map { |trans| trans.invoice_id}
     if paid_invoices_ids.include?(id)
      true
     end
   end

   def invoice_items
     invoice_items = SalesEngine.invoice_items
     invoices = SalesEngine.invoices
     invoice = invoices.find_by_id(id)
     if invoice.is_paid_in_full?
       invoice_items.find_all_by_invoice_id(id)
     end
   end

   def total
     items
     subtotals = invoice_items.map { |i_item| i_item.unit_price * i_item.quantity }
     total_bd = subtotals.reduce { |sum, num| (sum + num)}
     total_dollars = total_bd.to_f/100
     round_total = total_dollars.round(2)
     data.merge!({:total => round_total})
     total_bd/100
   end
end
