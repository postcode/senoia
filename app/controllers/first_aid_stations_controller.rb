class FirstAidStationsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @provider =  Organization.find(params[:first_aid_station][:organization_id])
    @first_aid_station = @operation_period.first_aid_stations.create(first_aid_station_params)
    if @provider.present? && @provider.name != "Other"
      @first_aid_station.contact_name = @provider.name
      @first_aid_station.contact_phone = @provider.phone_number
      @first_aid_station.planning_contact_email = @provider.email
    end
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
               :organization_id,
               :contact_name,
               :contact_phone,
               :planning_contact_email,
               :lat,
               :lng,
               :service_area
              ])
  end
end
