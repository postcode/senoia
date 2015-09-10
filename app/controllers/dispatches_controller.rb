class DispatchesController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @dispatch = @operation_period.dispatchs.create(dispatch_params)
  end

  private

  def dispatch_params
    params
      .require(:dispatch)
      .permit([
               :name,
               :provider_id,
               :contact_name,
               :contact_phone,
               :lat,
               :lng
              ])
  end
end
