class PlansController < ApplicationController
  def index
    @plans = Plan.all

    respond_to do |format|
      format.html
      format.json { render json: @plans }
    end
  end
end