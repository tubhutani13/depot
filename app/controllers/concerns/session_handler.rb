module SessionHandler
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def allowed_inactivity_time
      @@allowed_inactivity_time
    end

    def auto_session_timeout(inactivity_time)
      @@allowed_inactivity_time = inactivity_time
      before_action :logout_if_inactive, if: :user_session_exists?
    end
  end

  def logout_if_inactive
    
    if Time.current - session[:last_request_time].to_time >= self.class.allowed_inactivity_time
      logout
    else
      session[:last_request_time] = Time.current
    end
  end

  def user_session_exists?
    session[:user_id].present?
  end

  def logout
    reset_session
    redirect_to store_index_url, notice: "Logged out"
  end
end
