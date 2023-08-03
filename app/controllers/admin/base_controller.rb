class Admin::BaseController < ApplicationController
  before_action :authorize_admin

  protected def authorize_admin
    unless current_user.admin?
      redirect_to store_index_path, notice: "You don't have privilege to access this section"
    end
  end
end
