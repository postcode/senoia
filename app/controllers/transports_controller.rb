class TransportsController < ApplicationController
  before_action :check_params, only: [:update]

  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @transport = @operation_period.transports.create(transport_params)
    @provider =  Organization.find(params[:transport][:organization_id])
    if @provider.present? && @provider.name != "Other"
      @transport.contact_name = @provider.name
      @transport.contact_phone = @provider.phone_number
      @transport.planning_contact_email = @provider.email
    else
      @transport.organization = Organization.where(name: params[:organization_name]).first_or_create do |organization|
        organization.organization_type = OrganizationType.find_by_name("EMS Provider")
        organization.phone_number = params[:transport][:contact_phone]
        organization.email = params[:transport][:planning_contact_email]
      end
      @transport.contact_name = @transport.organization.name
      @transport.contact_phone = @transport.organization.phone_number
      @transport.planning_contact_email = @transport.organization.email
    end
    @transport.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @transport = Transport.find(params[:id])
    return unless params[:transport]
    @transport.update(transport_params)
    if params[:transport][:communications].present?
      params[:transport][:communications].each do |communication|
        if params[:transport][:communication_description][communication[0]].present?
          @transport.asset_communications.create(communication_id: communication[1], transport_id: @transport.id, description: params[:transport][:communication_description][communication[0]])
        end
      end
    end
    @transport.save!
  end

  private

  def check_params
    return unless params[:transport]
  end

  def transport_params
    params
      .require(:transport)
      .permit([
               :name,
               :level,
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
