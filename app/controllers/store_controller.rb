class StoreController < ApplicationController
  include CurrentCart

  # Since, in application controller, we added authorize that will act as guard for all controllers
  # need to skip that action when request coming on this controller
  skip_before_action :authorize

  before_action :set_cart

  def index
    # Getting List of Products ordered by title
    @products = Product.order(:title)
  end
end
