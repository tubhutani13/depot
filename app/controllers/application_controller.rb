class ApplicationController < ActionController::Base
  include Timer
  include SessionHandler

  auto_session_timeout 5.minutes

  around_action :attach_time_in_header
  before_action :update_hit_counter, only: [:index, :show, :edit, :new]
  before_action :authorize
  before_action :attach_ip_in_header
  around_action :setup_locale

  protected def authorize
    unless current_user
      redirect_to login_url, notice: t('flash.session.login')
    end
  end

  protected def current_user
    @logged_in_user ||= User.find_by(id: session[:user_id])
  end

  protected def update_hit_counter
    if current_user
      @user_hit_count = current_user.hit_count.increment!(:count).count
    end

    @total_hit_count = HitCount.total_hit_count
  end

  protected def attach_time_in_header
    start_timer
    yield
    response.header['X-Responded-In'] = time_elapsed_in_milliseconds
  end

  protected def attach_ip_in_header
    @client_ip = request.ip
  end
  protected def setup_locale(&action)
    I18n.with_locale(User.languages[@logged_in_user.language || :en], &action)
  end
end
