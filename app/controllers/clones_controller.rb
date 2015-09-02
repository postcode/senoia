class ClonesController < ApplicationController

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @plan = @operation_period.plan
    authorize! :manage, @plan
    
    @clone = @operation_period.deep_clone(include: [ :first_aid_stations, :mobile_teams, :transports, :dispatchs ])
    @clone.save
    @count = @plan.operation_periods.count
  end

end


