class OrdersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]

  include CurrentCart

  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.build_address
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    # Adding items from current cart to order
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        # Sending the method as background job
        ChargeOrderJob.perform_later(@order, pay_type_params.to_h)

        format.html { redirect_to store_index_url, notice: t("flash.notice.thank_you_for_order") }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to product_url(@product), notice: "Product #{t("flash.notice.successfull_update")}" }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product #{t('flash.notice.successfull_destroy')}" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:name, :email, :pay_type, address_attributes: [:state, :country, :city, :pincode])
  end

  # returns params relevant to chosen pay type
  def pay_type_params
    if order_params[:pay_type] == "Credit card"
      params.require(:order).permit(:credit_card_number, :expiration_date)
    elsif order_params[:pay_type] == "Check"
      params.require(:order).permit(:routing_number, :account_number)
    elsif order_params[:pay_type] == "Purchase order"
      params.require(:order).permit(:po_number)
    else
      {}
    end
  end

  def ensure_cart_isnt_empty
    # If cart is empty, redirect user to store index page
    if @cart.line_items.empty?
      redirect_to store_index_url, notice: "Your cart is empty"
    end
  end
end
