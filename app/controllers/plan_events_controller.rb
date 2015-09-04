class PlanEventsController < ApplicationController

  def create
    @plan = Plan.find(params[:plan_id])
    case params[:event]
    when "submit"
      authorize! :manage, @plan
      @plan.submit!
    end
    redirect_to @plan
  end

end
