class CategoriesController < ApplicationController
  def index
    @categories = Category.root_categories.includes(:sub_categories)
  end
end
