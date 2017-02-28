class TransportsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @transport = @operation_period.transports.create(transport_params)
    @transport.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @transport = Transport.find(params[:id])
    return unless params[:transport]
    @transport.update(transport_params)
    if params[:transport][:communications].present?
      params[:transport][:communications].each do |communication|
        if params[:transport][:communication_description][communication[0]].present?
          @transport.asset_communications.create(communication_id: communication[1], transport_id: @transport.id, description: params[:transport][:communication_description][communication[0]])
        end
      end
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
               :organization_id,
               :contact_name,
               :contact_phone,
               :planning_contact_email,
               :lat,
               :lng,
               :service_area,
               :location
              ])
  end
end
