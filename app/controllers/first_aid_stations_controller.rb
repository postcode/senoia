class FirstAidStationsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @first_aid_station = @operation_period.first_aid_stations.create(first_aid_station_params)
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
               :lng
              ])
  end
end
