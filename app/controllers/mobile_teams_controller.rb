class MobileTeamsController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @provider =  Organization.find(params[:mobile_team][:organization_id])
    @mobile_team = @operation_period.mobile_teams.create(mobile_team_params)
    if @provider.present? && @provider.name != "Other"
      @mobile_team.contact_name = @provider.name
      @mobile_team.contact_phone = @provider.phone_number
      @mobile_team.planning_contact_email = @provider.email
    end
    @mobile_team.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @mobile_team = MobileTeam.find(params[:id])
    @mobile_team.update(mobile_team_params)

    # params[:mobile_team][:communications].each do |communication|
    #   if params[:mobile_team][:communication_description][communication[0]].present?
    #     @mobile_team.asset_communications.create(communication_id: communication[1], mobile_team_id: @mobile_team.id, description: params[:mobile_team][:communication_description][communication[0]])
    #   end
    # end
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
