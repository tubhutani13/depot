## Responible for maintaining session related information for Cart
module CurrentCart
  ## Marking methods as private prevents them from exposing as HTTP requests
  # ie, it will prevent the method to be available as action on controller
  private def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    # Creating cart if does not exist and setting its id in session
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end