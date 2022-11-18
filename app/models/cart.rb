class Cart < ApplicationRecord
  ## Allows traversing from parent to child in relation
  # dependent declares ON DELETE CASCADE dependency over lineitems for a cart
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
    else
      # build method builds a lineitem with relationship between line_item object and product
      current_item = line_items.build(product_id: product.id)
    end

    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end
