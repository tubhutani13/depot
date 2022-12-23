class ProductsController < ApplicationController
  include ProductsHelper

  before_action :set_product, only: %i[ show edit update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_product

  # GET /products or /products.json
  def index
    if params[:category_id]
      @products = Product.where(category_id: params[:category_id]).order(:title)
    else
      @products = Product.all.order(:title)
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all.pluck(:name, :id)
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }

        ## Using Channel to send entire catalog every time update is made
        @products = Product.all.order(:title) # Required as this is used in store/index
        ## render_to_string renders according to same rules as render,
        # but returns the result in string instead of sending it as response body to browser
        # data sent as key-value pair
        # layout: false specifies that we only want view and not entire application layout page
        ActionCable.server.broadcast("products", {
          html: render_to_string("store/index", layout: false),
        })
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # /products/1/who_bought.atom
  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond_to do |format|
        # This will look for template name who_bought.atom.builder
        format.atom
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(
      :title, :description, :image_url, :price,
      :enabled, :discount_price, :permalink, :category_id, images: [],
    )
  end

  def invalid_product
    logger.error "Attempt to access invalid product #{params[:id]}"

    redirect_to products_url, notice: "Invalid Product"
  end
end
