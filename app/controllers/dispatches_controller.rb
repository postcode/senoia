class DispatchesController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @dispatch = @operation_period.dispatchs.create(dispatch_params)
    @dispatch.communications = Communication.where(id: params[:dispatch][:communications])
    @dispatch.asset_communications.last.update_attributes(description: params[:dispatch][:communication_description])
    @dispatch.asset_communications.last.save!
    @dispatch.save!
  end

  private

  def dispatch_params
    params
      .require(:dispatch)
      .permit([
               :name,
               :level,
               :aed,
               :provider_id,
               :contact_name,
               :contact_phone,
               :lat,
               :lng,
               :service_area
              ])
  end
end
