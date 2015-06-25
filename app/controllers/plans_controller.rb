class PlansController < ApplicationController
  load_and_authorize_resource
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  require 'pry'

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
    @plan = Plan.all.includes(:operation_periods).where(id: params[:id]).first
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
    @operation_period = OperationPeriod.create(operation_periods_params)
    @operation_period.start_date = DateTime.strptime(operation_periods_params[:start_date], '%m/%d/%Y %H:%M %p')
    @operation_period.end_date = DateTime.strptime(operation_periods_params[:end_date], '%m/%d/%Y %H:%M %p')
    @operation_period.save
    binding.pry
    @plan.operation_periods << @operation_period
    if params[:first_aid_stations].present? 
      @first_aid_station = FirstAidStation.create(params[:plan][:first_aid_stations])
      @operation_period.first_aid_stations << @first_aid_station
    end
    if @plan.save
      @plan.submit!
      redirect_to plans_path
    else
      redirect_to new_plan_path(@plan), alert: @plan.errors
    end
  end

  def add_comment
    @plan = Plan.find(params[:id])
    if params[:element_id].blank?
      @comment = Comment.build_from(@plan, current_user.id, params[:comment_text], Comment.find(params[:comment_id]).element_id)
    else
      @comment = Comment.build_from(@plan, current_user.id, params[:comment_text], params[:element_id])
    end
    @comment.save
    if params[:comment_id].present?
      @comment.move_to_child_of(Comment.find(params[:comment_id]))
      @comment.save
    end
    respond_to do |format|
      format.js
    end
    
  end

  def resolve_comment
    @plan = Plan.find(params[:id])
    @comment = Comment.find(params[:comment_id])
    @comment.open = false
    @comment.save
    respond_to do |format|
      format.js
    end
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def plan_params
      params.require(:plan).permit(:name, :event_type, :owner, :alcohol, :event_type_id, :permitter_id, :workflow_state, :owner_id, users_attributes: [:id, :email, :password, :address, :roles, :roles_mask, :phone_number], event_types_attributes: [:id, :name, :description], permitters_attributes: [:id, :name, :address, :phone_number], first_aid_stations_attributes: [:id, :name, :level, :md, :rn, :emt, :aed,:provider_id, :operation_period_id], user_attributes: [:id, :email, :password, :address, :roles, :roles_mask, :phone_number], mobile_teams_attributes: [:id, :name, :level, :provider_id], dispatchs_attributes: [:id, :name, :level], transports_attributes: [:id, :name, :level])
    end

    def operation_periods_params
      params.require(:operation_periods).permit(:id, :start_date, :end_date, :attendance, :plan_id)
    end
end