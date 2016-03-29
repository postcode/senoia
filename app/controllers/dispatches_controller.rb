class DispatchesController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @dispatch = @operation_period.dispatchs.create(dispatch_params)
    # params[:dispatch][:communications].each do |communication|
    #   @dispatch.communications << Communication.where(id: communication[1])
    #   @dispatch.asset_communications.create(communication_id: communication[1], dispatch_id: @dispatch.id, description: params[:dispatch][:communication_description][communication[0]])
    # end
    @dispatch.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @dispatch = Dispatch.find(params[:id])
    params[:dispatch][:communications].each do |communication|
      if communication[1].present?
        @dispatch.communications << Communication.where(id: communication[1])
        @dispatch.asset_communications.create(communication_id: communication[1], dispatch_id: @dispatch.id, description: params[:dispatch][:communication_description][communication[0]])
      end
    end
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
