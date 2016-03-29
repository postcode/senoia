class FirstAidStationsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @first_aid_station = @operation_period.first_aid_stations.create(first_aid_station_params)
    @first_aid_station.contact_name = @first_aid_station.provider.name unless @first_aid_station.provider.blank?
    @first_aid_station.contact_phone = @first_aid_station.provider.phone_number unless @first_aid_station.provider.blank?
    @first_aid_station.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @first_aid_station = FirstAidStation.find(params[:id])
    params[:first_aid_station][:communications].each do |communication|
      if params[:first_aid_station][:communication_description][communication[0]].present?
        @first_aid_station.asset_communications.create(communication_id: communication[1], first_aid_station_id: @first_aid_station.id, description: params[:first_aid_station][:communication_description][communication[0]])
      end
    end
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
