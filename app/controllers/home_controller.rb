class HomeController < ApplicationController
  def index
    @plans = Plan.all
    @operation_period = OperationPeriod.all
    @invitations = current_user.try(:invitations) || []
    
    respond_to do |format|
      format.html
      format.json { render json: @plans }
    end
  end
end
