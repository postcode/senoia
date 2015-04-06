class PlansController < ApplicationController
  require 'pry'

  def index
    @plans = Plan.all
    respond_to do |format|
      format.html
      format.json { render json: @plans }
    end
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def plan_params
      params.require(:plan).permit(:name, :start_date, :end_date, :attendance, :event_type, :owner)
    end
end