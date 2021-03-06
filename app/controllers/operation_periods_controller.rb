class OperationPeriodsController < ApplicationController

  def new
    @plan = Plan.find(params[:plan_id])
    @count = @plan.operation_periods.count + 1
  end

  def create
    @plan = Plan.find(params[:plan_id])
    params[:operation_period][:attendance]= params[:operation_period][:attendance].gsub(/\D/, '').to_i
    @operation_period = @plan.operation_periods.create(operation_period_params)
    @count = @plan.operation_periods.count
    @asset_text = AssetAllocationService.new(type: @plan.event_type, crowd_size: @operation_period.attendance).asset_text
    @plan.add_start_end_dates
  end

  def destroy
    @operation_period = OperationPeriod.find(params[:id])
    authorize! :manage, @operation_period.plan
    delete_open_comments
    @operation_period.destroy
  end

  def update
    @operation_period = OperationPeriod.find(params[:id])
    @plan = @operation_period.plan
    params[:operation_period][:attendance] = params[:operation_period][:attendance].gsub(/\D/, '').to_i unless params[:operation_period][:attendance].nil?
    params[:operation_period][:crowd_estimate] = params[:operation_period][:crowd_estimate].gsub(/\D/, '').to_i unless params[:operation_period][:crowd_estimate].nil?
    authorize! :manage, @operation_period.plan
    @operation_period.update(operation_period_params)
    render nothing: true
    @asset_text = AssetAllocationService.new(type: @plan.event_type, crowd_size: @operation_period.attendance).asset_text
    @plan.add_start_end_dates
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
              :end_time,
              :service_area,
              :crowd_estimate,
              :location)
  end

  def delete_open_comments
    @plan = @operation_period.plan
    @open_comments = @plan.comments.select { |c| c.element_id.starts_with?(@operation_period.id.to_s) }
    @open_comments.each(&:delete)
  end
end

