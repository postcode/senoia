class TransportsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @transport = @operation_period.transports.create(transport_params)
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
               :lng
              ])
  end
end
