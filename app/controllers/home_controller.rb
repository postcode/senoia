class HomeController < ApplicationController
  def index
    @plans = Plan.all
    @operation_period = OperationPeriod.all
    
    respond_to do |format|
      format.html
      format.json { render json: @plans }
    end
  end

  def learn_more
    render 'home/learn_more'
  end
end
