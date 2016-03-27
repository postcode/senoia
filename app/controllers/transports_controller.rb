class TransportsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @transport = @operation_period.transports.create(transport_params)
    @transport.communications = Communication.where(id: params[:transport][:communications])
    @transport.asset_communications.last.update_attributes(description: params[:transport][:communication_description])
    @transport.asset_communications.last.save!
    @transport.save!
  end

  private

  def transport_params
    params
      .require(:transport)
      .permit([
               :name,
               :level,
               :provider_id,
               :contact_name,
               :contact_phone,
               :lat,
               :lng,
               :service_area
              ])
  end
end
