class PlansController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  helper_method :view_own_plans?

  def index
    plans_scope = Plan.includes(:operation_periods, :event_type).calculating_total_attendance

    if view_own_plans?
      plans_scope = plans_scope.affiliated_to(current_user)
    elsif !current_user.try(:admin?)
      plans_scope = plans_scope.with_approved_state
    end

    plans_scope = plans_scope.search(params[:query] || { })

    @plans = smart_listing_create(:plans,
                                  plans_scope,
                                  partial: 'plans/listing',
                                  default_sort: { "plans.created_at" => "desc" })
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @plans }
    end
  end

  def show
    authorize! :view, Plan
    @plan = Plan.all.includes(:operation_periods).where(id: params[:id]).first
    @count = 0
    @permitters = Permitter.order("name ASC")

    if @plan.present?
      if @plan.approved?
        if current_user.try(:is_admin?)
          respond_to do |format|
            format.html do
              render "plans/show_approved"
            end
            format.pdf do
              render pdf: "#{@plan.name}",   # Excluding ".pdf" extension.
              template: "plans/pdf/plan.pdf.erb"
            end
          end
        else
          respond_to do |format|
            format.html do
              render "plans/show"
            end
            format.pdf do
              render pdf: "#{@plan.name}",   # Excluding ".pdf" extension.
              template: "plans/pdf/plan.pdf.erb"
            end
          end
        end
      elsif can? :edit, @plan
        render "plans/edit"
      else
        redirect_to plans_path
      end
    else
      redirect_to plans_path
    end
  end

  def new
    authorize! :create, Plan, message: "Sorry, you are not authorized to create a new plan."
    @plan = Plan.new

    respond_to do |format|
      format.html
      format.json { render json: @plan }
    end
  end

  def create
    authorize! :create, Plan, message: "Sorry, you are not authorized to create a new plan."
    @plan = Plan.create(plan_params.merge(creator: current_user, owner: current_user))
    if !@plan.valid?
      flash.now[:alert] = @plan.errors.full_messages.to_sentence
      render action: :new
    else
      redirect_to plan_path(@plan)
    end
  end

  def update
    @plan = Plan.find(params[:id])

    @plan.update(plan_params)

    plan_params[:operation_periods_attributes].try(:each) do |op|
      next unless op[1][:id]
      @operation_period = @plan.operation_periods.find(op[1][:id])

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

      @operation_period.save
    end

    if params[:user].present?
      params[:user].each do |user|
        user_obj = User.find_by_email(user[1][:email])
        @plan.users.create(user: user_obj, role: user[1][:role])
      end
    end

    respond_to do |format|
      if @plan.valid?
        format.html { redirect_to @plan, notice: 'plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
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

  def update_acceptance
    @category = params[:category]
    @plan = Plan.find(params[:plan_id])
    @plan.paper_trail_event = "update #{@category}"
    @plan.update_attribute("#{@category}", true)
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
    params
      .require(:plan)
      .permit(:name,
              :event_type,
              :owner,
              :alcohol,
              :event_type_id,
              :organization_id,
              :owner_id,
              :post_event_name,
              :post_event_email,
              :post_event_phone,
              :responsibility,
              :cpr,
              :communication,
              :communication_phone,
              :event_contact,
              :venue_ids,
              venue_attributes: [
                :id,
                :name],
              users_attributes: [
                                 :id,
                                 :email,
                                 :password,
                                 :address,
                                 :roles,
                                 :roles_mask,
                                 :phone_number
                                ],
              event_types_attributes: [
                                       :id,
                                       :name,
                                       :description
                                      ],
              permitters_attributes: [
                                      :id,
                                      :name,
                                      :address,
                                      :phone_number
                                     ],
              user_attributes: [
                                :id,
                                :email,
                                :password,
                                :address,
                                :roles,
                                :roles_mask,
                                :phone_number
                               ],
              :user_ids => [ ],
              operation_periods_attributes: [
                                             :id,
                                             :attendance,
                                             :start_date,
                                             :end_date,
                                             :start_time,
                                             :end_time,
                                             :service_area,
                                             :crowd_estimate,
                                             first_aid_stations_attributes: [
                                                                             :name,
                                                                             :level,
                                                                             :md,
                                                                             :rn,
                                                                             :emt,
                                                                             :aed,
                                                                             :organization_id,
                                                                             :contact_name,
                                                                             :contact_phone,
                                                                             :planning_contact_email,
                                                                             :id,
                                                                             :location,
                                                                             :_destroy
                                                                            ],
                                             transports_attributes: [
                                                                     :id,
                                                                     :name,
                                                                     :level,
                                                                     :organization_id,
                                                                     :contact_name,
                                                                     :contact_phone,
                                                                     :planning_contact_email,
                                                                     :location,
                                                                     :_destroy
                                                                    ],
                                             mobile_teams_attributes: [
                                                                       :id,
                                                                       :name,
                                                                       :level,
                                                                       :aed,
                                                                       :organization_id,
                                                                       :contact_name,
                                                                       :contact_phone,
                                                                       :planning_contact_email,
                                                                       :location,
                                                                       :_destroy
                                                                      ],
                                             dispatchs_attributes: [
                                                                    :id,
                                                                    :name,
                                                                    :level,
                                                                    :organization_id,
                                                                    :contact_name,
                                                                    :contact_phone,
                                                                    :planning_contact_email,
                                                                    :location,
                                                                    :_destroy
                                                                   ]
                                            ]
              )
  end

  def operation_periods_params
    params.require(:operation_periods).permit(id:
                                              [
                                               :start_date,
                                               :end_date,
                                               :start_time,
                                               :end_time,
                                               :attendance,
                                               :plan_id,
                                               :service_area,
                                               :crowd_estimate,
                                               first_aid_stations: [
                                                                    id:[
                                                                        :name,
                                                                        :level,
                                                                        :md,
                                                                        :rn,
                                                                        :emt,
                                                                        :aed,
                                                                        :organization_id,
                                                                        :contact_name,
                                                                        :contact_phone,
                                                                        :planning_contact_email,
                                                                        :location,
                                                                        :id,
                                                                        :lat,
                                                                        :lng,
                                                                        :service_area
                                                                       ]
                                                                   ],
                                               transport: [
                                                           id: [
                                                                :name,
                                                                :level,
                                                                :organization_id,
                                                                :contact_name,
                                                                :contact_phone,
                                                                :planning_contact_email,
                                                                :location,
                                                                :lat,
                                                                :lng,
                                                                :service_area
                                                               ]
                                                          ],
                                               mobile_teams: [
                                                              id: [
                                                                   :name,
                                                                   :level,
                                                                   :aed,
                                                                   :organization_id,
                                                                   :contact_name,
                                                                   :contact_phone,
                                                                   :planning_contact_email,
                                                                   :location,
                                                                   :lat,
                                                                   :lng,
                                                                   :service_area
                                                                  ]
                                                             ],
                                               dispatch: [
                                                          id: [
                                                               :name,
                                                               :level,
                                                               :organization_id,
                                                               :contact_name,
                                                               :contact_phone,
                                                               :planning_contact_email,
                                                               :location,
                                                               :lat,
                                                               :lng,
                                                               :service_area
                                                              ]
                                                         ]
                                              ])
  end

  def view_own_plans?
    return false unless current_user
    return true if params[:my_plans] == "1"
    return false if params[:my_plans] == "0"
    return true if current_user.affiliated_plans.exists?
    return false
  end

end
