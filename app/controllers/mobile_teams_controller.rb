class MobileTeamsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @mobile_team = @operation_period.mobile_teams.create(mobile_team_params)
    params[:mobile_team][:communications].each do |communication|
      @mobile_team.communications << Communication.where(id: communication[1])
      @mobile_team.asset_communications.create(communication_id: communication[1], mobile_team_id: @mobile_team.id, description: params[:mobile_team][:communication_description][communication[0]])
    end
    @mobile_team.save!
  end

  private

  def mobile_team_params
    params
      .require(:mobile_team)
      .permit([
               :name,
               :level,
               :mobile_team_type,
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
