class DispatchesController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @provider = Organization.find(params[:dispatch][:organization_id])
    @dispatch = @operation_period.dispatchs.create(dispatch_params)
    if @provider.present? && @provider.name != "Other"
      @dispatch.contact_name = @provider.name
      @dispatch.contact_phone = @provider.phone_number
      @dispatch.planning_contact_email = @provider.email
    else
      @dispatch.organization = Organization.where(name: params[:organization_name]).first_or_create do |organization|
        organization.organization_type = OrganizationType.find_by_name("EMS Provider")
        organization.phone_number = params[:dispatch][:contact_phone]
        organization.email = params[:dispatch][:planning_contact_email]
      end
      @dispatch.contact_name = @dispatch.organization.name
      @dispatch.contact_phone = @dispatch.organization.phone_number
      @dispatch.planning_contact_email = @dispatch.organization.email
    end
    @dispatch.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @dispatch = Dispatch.find(params[:id])
    return unless params[:dispatch]
    @dispatch.update(dispatch_params)
    if params[:dispatch][:communications].present?
      params[:dispatch][:communications].each do |communication|
        if params[:dispatch][:communication_description][communication[0]].present?
          @dispatch.asset_communications.create(communication_id: communication[1], dispatch_id: @dispatch.id, description: params[:dispatch][:communication_description][communication[0]])
        end
      end
    end
    @dispatch.save!
  end

  private

  def dispatch_params
    params
      .require(:dispatch)
      .permit([
               :name,
               :level,
               :aed,
               :organization_id,
               :contact_name,
               :contact_phone,
               :planning_contact_email,
               :lat,
               :lng,
               :service_area,
               :location
              ])
  end
end
