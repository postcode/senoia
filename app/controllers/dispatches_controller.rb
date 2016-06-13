class DispatchesController < ApplicationController
  def new
  end

  def create
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @provider =  Organization.find(params[:dispatch][:organization_id])
    @dispatch = @operation_period.dispatchs.create(dispatch_params)
    if @provider.present? && @provider.name != "Other"
      @dispatch.contact_name = @provider.name
      @dispatch.contact_phone = @provider.phone_number
      @dispatch.planning_contact_email = @provider.email
    end
    @dispatch.save!
  end

  def update
    @operation_period = OperationPeriod.find(params[:operation_period_id])
    @dispatch = Dispatch.find(params[:id])
    params[:dispatch][:communications].each do |communication|
      if params[:dispatch][:communication_description][communication[0]].present?
        @dispatch.asset_communications.create(communication_id: communication[1], dispatch_id: @dispatch.id, description: params[:dispatch][:communication_description][communication[0]])
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
               :service_area
              ])
  end
end
