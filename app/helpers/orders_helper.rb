module OrdersHelper
  def order_total(order)
    number_to_currency(total_price(order.line_items))
  end
end
