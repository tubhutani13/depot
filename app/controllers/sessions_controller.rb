

class SessionsController < ApplicationController
  skip_before_action :authorize
  skip_before_action :logout_if_inactive
  
  def new
  end

  def create
    user = User.find_by(name: params[:name])

    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:last_request_time] = Time.current
      if user.admin?
        redirect_to admin_path
      else
        redirect_to store_index_path
      end
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    logout
  end
end
