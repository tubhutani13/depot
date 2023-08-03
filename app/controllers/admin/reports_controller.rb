class Admin::ReportsController < Admin::BaseController
  def index
    @from = params[:from]
    @to = params[:to]

    if valid_params?
      flash.now[:notice] = "Please mention both From and To field"
      render :index and return
    end

    if params[:from].present? && params[:to].present?
      @orders = Order.by_date(params[:from], params[:to])
    else
      @orders = Order.by_date(5.days.ago, Time.now)
    end
  end

  private def valid_params?
    params[:from].present? && params[:to].blank? || params[:from].blank? && params[:to].present?
  end
end
