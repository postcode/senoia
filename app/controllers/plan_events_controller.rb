class PlanEventsController < ApplicationController

  def create
    @plan = Plan.find(params[:plan_id])
    case params[:event]
    when "submit"
      authorize! :manage, @plan
      @plan.submit!
    when "accept"
      authorize! :manage, Plan
      @plan.accept!
    when "review"
      authorize! :manage, Plan
      @plan.review!
    when "reject"
      authorize! :manage, Plan
      @plan.reject!
    end
    redirect_to @plan
  end

end
