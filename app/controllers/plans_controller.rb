class PlansController < ApplicationController
  load_and_authorize_resource
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    if !current_user.nil? && current_user.is_admin?
      plans_scope = Plan.all.includes(:operation_periods, :event_type)
    else
      plans_scope = Plan.with_accepted_state.includes(:operation_periods, :event_type)
    end
    plans_scope = plans_scope.owner(current_user.id) if params[:my_plans_check] == '1'
    plans_scope = Plan.like(params[:filter]) if params[:filter]
    plans_scope = plans_scope.alcohol if params[:alcohol_check] == '1'
    plans_scope = plans_scope.with_accepted_state if params[:accepted_check] == '1'
    plans_scope = plans_scope.with_draft_state if params[:submitted_check] == '1'
    plans_scope = plans_scope.with_awaiting_review_state if params[:awaiting_review_check] == '1'
    plans_scope = plans_scope.with_being_reviewed_state if params[:reviewing_check] == '1'
    plans_scope = plans_scope.attendance(0, 2500) if params[:filter_2500] == '1'
    plans_scope = plans_scope.attendance(2500, 15500) if params[:filter_2500_15500] == '1'
    plans_scope = plans_scope.attendance(15500, 50000) if params[:filter_15500_50000] == '1'
    plans_scope = plans_scope.event_type(event_type: params[:eventtype]) if params[:eventtype]
    plans_scope = plans_scope.attendance(50000, 1000000000) if params[:filter_500000] == '1'
    @plans = smart_listing_create(:plans, plans_scope, partial: 'plans/listing', sort_attributes: [
                          [:name, 'plans.name'],
                          [:event_type, 'plans.event_type'],
                          [:attendance, 'plans.operation_periods.attendance']])
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @plans }
    end
  end

  def show
    @plan = Plan.all.includes(:operation_periods).where(id: params[:id]).first
    @count = 0
    if @plan.accepted?
      render 'plans/show_accepted'
    else
      render 'plans/show'
    end
  end

  def new
    @plan = Plan.new
    @plan.operation_periods.build
    
    respond_to do |format|
      format.html
      format.json { render json: @plan }
    end
  end  

  def create
    @plan = Plan.create(plan_params.merge(creator: current_user, owner: current_user))

    if params[:user].present?
      params[:user].each do |user|
        @plan.users << User.where(email: user[1][:email]).first
        p = PlanUser.where(plan_id: @plan.id, user_id: user).first
        p.role = user[1][:role]
        p.save
      end
    end

    if @plan.save
      @plan.submit!
      redirect_to plan_path(@plan)
    else
      redirect_to new_plan_path(@plan), alert: @plan.errors
    end
  end

  def update
    @plan = Plan.find(params[:id])
    plan_params[:operation_periods_attributes].each do |op|
      @operation_period = @plan.operation_periods.find(op[1][:id])
      if op[1][:first_aid_stations_attributes].present? 
        op[1][:first_aid_stations_attributes].each do |first_aid|
          @first_aid_update = FirstAidStation.find(first_aid[1][:id]).update_attributes(first_aid[1])
        end
      end

      if op[1][:mobile_teams_attributes].present? 
        op[1][:mobile_teams_attributes].each do |mobile|
          @mobile_team_update = MobileTeam.find(mobile[1][:id]).update_attributes(mobile[1])
        end
      end

      if op[1][:transports_attributes].present? 
        op[1][:transports_attributes].each do |transport|
          @transport_team_update = Transport.find(transport[1][:id]).update_attributes(transport[1])
        end
      end

      if op[1][:dispatchs_attributes].present? 
        op[1][:dispatchs_attributes].each do |dispatch|
          @dispatch_team_update = Dispatch.find(dispatch[1][:id]).update_attributes(dispatch[1])
        end
      end

      if params[op[1][:id]].present?
        if params[op[1][:id]][:transport].present?
          params[op[1][:id]][:transport].each do |t|
            @operation_period.transports << Transport.create(t[1].flatten[1])
          end
        end

        if params[op[1][:id]][:first_aid_stations].present?
          params[op[1][:id]][:first_aid_stations].each do |t|
            @operation_period.first_aid_stations << FirstAidStation.create(t[1].flatten[1])
          end
        end

        if params[op[1][:id]][:mobile_teams].present?
          params[op[1][:id]][:mobile_teams].each do |t|
            @operation_period.mobile_teams << MobileTeam.create(t[1].flatten[1])
          end
        end

        if params[op[1][:id]][:dispatch].present?
          params[op[1][:id]][:dispatch].each do |t|
            @operation_period.dispatchs << Dispatch.create(t[1].flatten[1])
          end
        end
      end

      if params[:user].present?
        params[:user].each do |user|
          @plan.users << User.where(email: user[1][:email]).first
          p = PlanUser.where(plan_id: @plan.id, user_id: user).first
          p.role = user[1][:role]
          p.save
        end
      end

      @operation_period.save
    end
    respond_to do |format|
      if @plan.update_attributes(plan_params)
        format.html { redirect_to @plan, notice: 'plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def request_revision
    @plan = Plan.find(params[:id])
    if @plan.save
      @plan.review!
      redirect_to plans_path
    else
      redirect_to new_plan_path(@plan), alert: @plan.errors
    end
  end

  def approve
    @plan = Plan.find(params[:id])
    if @plan.save
      @plan.accept!
      redirect_to plans_path, notice: 'plan was approved.' 
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

  def add_first_aid_station
    @first_aid_station = params[:first_aid_station]
    @operation_period = params[:operation_period]
    @operation_period_index = params[:operation_period_index]
    respond_to do |format|
      format.js
    end
  end

  def update_first_aid_station
    @operation_period = params[:operation_period]
    @operation_period_index = params[:operation_period_index]
    # binding.pry
    respond_to do |format|
      format.js
    end
  end

  def add_mobile_team
    @operation_period = params[:operation_period].to_s
    respond_to do |format|
      format.js
    end
  end

  def add_transport
    @operation_period = params[:operation_period].to_s
    respond_to do |format|
      format.js
    end
  end

  def add_dispatch
    @operation_period = params[:operation_period].to_s
    respond_to do |format|
      format.js
    end
  end

  def add_operation_period
    @count = params[:count].to_i + 1
    @plan = Plan.new
    @operation_period = @plan.operation_periods.build
    respond_to do |format|
      format.js
    end
  end

  def add_user
    @edit_users = params[:edit_plan]
    @view_users = params[:view_plan]
    respond_to do |format|
      format.js
    end
  end

  def update_plan_user
    respond_to do |format|
      format.js
    end
  end

  def remove_user
    @plan = Plan.find(params[:plan_id])
    @plan_user = PlanUser.where(user_id: params[:user_id], plan_id: params[:plan_id])
    @plan_user.first.destroy
    redirect_to plan_path(@plan)
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def plan_params
      params.require(:plan).permit(:name, :event_type, :owner, :alcohol, :event_type_id, :permitter_id, :workflow_state, :owner_id, :post_event_name, :post_event_email, :post_event_phone, :responsibility, :cpr, :communication, :event_contact, users_attributes: [:id, :email, :password, :address, :roles, :roles_mask, :phone_number], event_types_attributes: [:id, :name, :description], permitters_attributes: [:id, :name, :address, :phone_number], user_attributes: [:id, :email, :password, :address, :roles, :roles_mask, :phone_number], :user_ids => [], operation_periods_attributes: [:id, :attendance, :start_date, :end_date, first_aid_stations_attributes: [:name, :level, :md, :rn, :emt, :aed, :provider_id, :contact_name, :contact_phone, :id, :location], transports_attributes: [:id, :name, :level, :provider_id, :contact_name, :contact_phone, :location], mobile_teams_attributes: [:id, :name, :level, :aed, :provider_id, :contact_name, :contact_phone, :location], dispatchs_attributes: [:id, :name, :level, :provider_id, :contact_name, :contact_phone, :location]])
    end

    def operation_periods_params
      params.require(:operation_periods).permit(id:[:start_date, :end_date, :attendance, :plan_id, first_aid_stations: [id:[:name, :level, :md, :rn, :emt, :aed, :provider_id, :contact_name, :contact_phone, :location, :id, :lat, :lng]], transport: [id: [:name, :level, :provider_id, :contact_name, :contact_phone, :location, :lat, :lng]], mobile_teams: [id: [:name, :level, :aed, :provider_id, :contact_name, :contact_phone, :location, :lat, :lng]], dispatch: [id: [:name, :level, :provider_id, :contact_name, :contact_phone, :location]]])
    end
end
