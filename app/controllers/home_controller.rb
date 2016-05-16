class HomeController < ApplicationController
  def index

    @plans = Plan.with_approved_state
    @operation_period = OperationPeriod.all_approved

    respond_to do |format|
      format.html
      format.json { render json: @plans }
    end
  end

  def learn_more
    render 'home/learn_more'
  end
end
