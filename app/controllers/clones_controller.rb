class ClonesController < ApplicationController

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @plan = @operation_period.plan
    authorize! :manage, @plan

    @clone = @operation_period.deep_clone(include: [ :first_aid_stations, :mobile_teams, :transports, :dispatchs ])
    @clone.save
    @count = @plan.operation_periods.count
  end

  def new_plan
    @plan = Plan.find(params[:plan_id])
    authorize! :manage, @plan

    @clone = @plan.deep_clone(except: :workflow_state, include: {operation_periods: [ :first_aid_stations, :mobile_teams, :transports, :dispatchs ] })
    if @clone.save
      redirect_to plan_path(@clone), notice: "Plan successfully duplicated."
    end
  end

end


