class RatingsController < ApplicationController
  def create
    @rating = Rating.find_or_initialize_by(rating_params)
    @rating.rating = params[:rating]

    respond_to do |format|
      if @rating.save
        format.json { render json: :created }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def rating_params
    params.permit([:product_id]).merge(user_id: session[:user_id])
  end
end
