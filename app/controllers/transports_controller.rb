class TransportsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @transport = @operation_period.transports.create(transport_params)
    params[:transport][:communications].each do |communication|
      @transport.communications << Communication.where(id: communication[1])
      @transport.asset_communications.create(communication_id: communication[1], transport_id: @transport.id, description: params[:transport][:communication_description][communication[0]])
    end
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
