class LineItem < ApplicationRecord
  # These add navigation capabilities to model objects
  # Using these, product and cart info can be retrieved using line_item
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  validates :product, uniqueness: { 
    scope: :cart,
    message: "has already been taken in Cart."
  }
  
  ## Adding total_price method in model as model provides data to view 
  def total_price
    product.price * quantity
  end

end
