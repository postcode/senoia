class MobileTeamsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @mobile_team = @operation_period.mobile_teams.create(mobile_team_params)
  end

  private

  def mobile_team_params
    params
      .require(:mobile_team)
      .permit([
               :name,
               :level,
               :type,
               :aed,
               :provider_id,
               :contact_name,
               :contact_phone,
               :lat,
               :lng
              ])
  end
end
