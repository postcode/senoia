class MobileTeamsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @mobile_team = @operation_period.mobile_teams.create(mobile_team_params)
    @mobile_team.communications = Communication.where(id: params[:mobile_team][:communications])
    @mobile_team.asset_communications.last.update_attributes(description: params[:mobile_team][:communication_description])
    @mobile_team.asset_communications.last.save!
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
