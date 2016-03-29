class MobileTeamsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @mobile_team = @operation_period.mobile_teams.create(mobile_team_params)
    @mobile_team.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @mobilt_team = MobileTeam.find(params[:id])
    params[:mobilt_team][:communications].each do |communication|
      if params[:mobilt_team][:communication_description][communication[0]].present?
        @mobilt_team.asset_communications.create(communication_id: communication[1], mobilt_team_id: @mobilt_team.id, description: params[:mobilt_team][:communication_description][communication[0]])
      end
    end
    @mobilt_team.save!
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
