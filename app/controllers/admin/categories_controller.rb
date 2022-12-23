class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.root_categories.order(:name)
  end
end
