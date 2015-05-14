class PlansController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    @plans = smart_listing_create(:plans, Plan.all, partial: "plans/listing")
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
      redirect_to plans_path
    else
      redirect_to plan_new(@plan), alert: @plan.errors
    end
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def plan_params
      params.require(:plan).permit(:name, :start_date, :end_date, :attendance, :event_type, :owner, event_type_attributes: [:id, :name, :description], permitter_attributes: [:id, :name, :address, :phone_number], operation_period_attributes: [:id, :start_date, :end_date, :attendance, :plan_id])
    end
end