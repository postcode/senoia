class FirstAidStationsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @first_aid_station = @operation_period.first_aid_stations.create(first_aid_station_params)
    @first_aid_station.communications = Communication.where(id: params[:first_aid_station][:communications])
    @first_aid_station.asset_communications.last.update_attributes(description: params[:first_aid_station][:communication_description])
    @first_aid_station.asset_communications.last.save!
    @first_aid_station.save!
  end

  private

  def first_aid_station_params
    params
      .require(:first_aid_station)
      .permit([
               :name,
               :level,
               :md,
               :rn,
               :emt,
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
