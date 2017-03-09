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
      redirect_to @plan
      @plan.approve! if current_user.is_admin?
      return
    when "request_revision"
      authorize! :manage, Plan
      @plan.request_revision! if current_user.is_admin?
    when "request_review"
      authorize! :manage, Plan
      @plan.request_review!
    when "reject"
      authorize! :manage, Plan
      @plan.reject! if current_user.is_admin?
    end
    redirect_to @plan
  end
end
