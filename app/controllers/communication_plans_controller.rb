class CommunicationPlansController < ApplicationController

  load_and_authorize_resource :plan
  load_and_authorize_resource :communication_plan, through: :plan, singleton: true
    
  def show
    @plan = Plan.find(params[:plan_id])
    unless @communication_plan
      @communication_plan = @plan.create_communication_plan
    end
    render action: :show
  end
  
  def update
    if @communication_plan.update(communication_plan_params)
      redirect_to action: :show
    else
      render action: :show
    end
  end

  private
  
  def communication_plan_params
    params.require(:communication_plan)
      .permit(:id,
              :event_coordinator_name,
              :event_coordinator_phone,
              :event_coordinator_email,
              :event_coordinator_organization,
              :event_supervisor_name,
              :event_supervisor_phone,
              :event_supervisor_email,
              :dispatch_supervisor_name,
              :dispatch_supervisor_phone ,
              :dispatch_supervisor_email,
              :dispatch_supervisor_organization,
              :medical_group_supervisor_name,
              :medical_group_supervisor_phone,
              :medical_group_supervisor_email,
              :medical_group_supervisor_organization,
              :triage_supervisor_name,
              :triage_supervisor_phone,
              :triage_supervisor_email,
              :triage_supervisor_organization,
              :transport_supervisor_name,
              :transport_supervisor_email,
              :transport_supervisor_phone,
              :transport_supervisor_organization ,
              :non_transport_supervisor_name,
              :non_transport_supervisor_email,
              :non_transport_supervisor_phone,
              :non_transport_supervisor_organization,
              :plan_id
              )
  end 
end
