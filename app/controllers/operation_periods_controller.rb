class OperationPeriodsController < ApplicationController

  def new
    @plan = Plan.find(params[:plan_id])
    @count = @plan.operation_periods.count + 1
  end
  
  def create
    @plan = Plan.find(params[:plan_id])
    @operation_period = @plan.operation_periods.create(operation_period_params)
    @count = @plan.operation_periods.count
  end
  
  def destroy
    @operation_period = OperationPeriod.find(params[:id])
    authorize! :manage, @operation_period.plan
    @operation_period.destroy
  end

  def update
    @operation_period = OperationPeriod.find(params[:id])
    authorize! :manage, @operation_period.plan
    @operation_period.update(operation_period_params)
    render nothing: true
  end

  private

  def operation_period_params
    params.require(:operation_period)
      .permit(:start_date,
              :end_date,
              :attendance,
              :patients_treated_count,
              :patients_transported_count,
              :start_time,
              :end_time)
  end

end

