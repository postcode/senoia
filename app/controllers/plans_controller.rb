class PlansController < ApplicationController
  load_and_authorize_resource
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    if !current_user.nil? && current_user.is_admin?
      plans_scope = Plan.all
    else
      plans_scope = Plan.with_accepted_state
    end
    @plans = smart_listing_create(:plans, plans_scope, partial: "plans/listing")
    respond_to do |format|
      format.html
      format.json { render json: @plans }
    end
  end

  def show
    @plan = Plan.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @plan = Plan.new
    respond_to do |format|
      format.html
      format.json { render json: @plan }
    end
  end  

  def create
    @plan = Plan.create(plan_params)
    if @plan.save
      @plan.submit!
      redirect_to plans_path
    else
      redirect_to new_plan_path(@plan), alert: @plan.errors
    end
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def plan_params
      params.require(:plan).permit(:name, :start_date, :end_date, :attendance, :event_type, :owner, :alcohol, :event_type_id, :permitter_id, :workflow_state, event_types_attributes: [:id, :name, :description], permitters_attributes: [:id, :name, :address, :phone_number], operation_periods_attributes: [:id, :start_date, :end_date, :attendance, :plan_id], users_attributes: [:id, :email, :password, :address, :roles, :roles_mask])
    end
end