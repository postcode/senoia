class PostEventTreatmentReportsController < ApplicationController
  # load_and_authorize_resource :plan
  # load_and_authorize_resource :post_event_treatment_report, through: :plan, singleton: true, except: [:index, :show]

  def index
    authorize! :read, :admin_only_items
    @post_event_treatment_reports = initialize_grid(PostEventTreatmentReport,
                                         include:  :plan,
                                         enable_export_to_csv: true,
                                         csv_file_name:        'events')
    export_grid_if_requested
  end

  def show
    @plan = Plan.find(params[:plan_id])
    @post_event_treatment_report = @plan.post_event_treatment_report
    authorize! :edit, @plan
    unless @post_event_treatment_report
      @post_event_treatment_report = @plan.create_post_event_treatment_report
    end
  end

  def update
    @plan = Plan.find(params[:plan_id])
    authorize! :edit, @plan
    @post_event_treatment_report = @plan.post_event_treatment_report
    if @post_event_treatment_report.update(post_event_treatment_report_params)
      @post_event_treatment_report.submit_email!
      PostEventTreatmentReportMailer.submit(recipient: User.find_by_email("aram.bronston@sfgov.org"), plan: @plan).deliver_later
      redirect_to action: :show
    else
      @post_event_treatment_report.submitted = false
      render action: :show
    end
  end

  private

  def post_event_treatment_report_params
    result = params.require(:post_event_treatment_report)
      .permit(:actual_crowd_size,
              :resource_differences,
              :medical_resource_sufficiency,
              :medical_resource_sufficiency_explanation,
              :other_comments)
    if params[:submit]
      result.merge!(submitted: true,
                    creator: current_user)

    end
    result
  end

end
