require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test

  def setup
    @ir = InvoiceItemRepository.new("./data/fixtures/invoice_items.csv")
  end
end
