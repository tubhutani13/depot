module LineItemsHelper
  def total_price(line_items)
    line_items.to_a.sum { |item| item.total_price }
  end
end
