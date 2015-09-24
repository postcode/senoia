class PlanEventsController < ApplicationController

  # TODO authorize admin state changes through cancan
  
  def create
    @plan = Plan.find(params[:plan_id])
    case params[:event]
    when "submit"
      authorize! :manage, @plan
      @plan.submit!
    when "approve"
      authorize! :manage, Plan
      @plan.approve! if current_user.is_admin?
    when "review"
      authorize! :manage, Plan
      @plan.review! if current_user.is_admin?
    when "reject"
      authorize! :manage, Plan
      @plan.reject! if current_user.is_admin?
    end
    redirect_to @plan
  end

end
