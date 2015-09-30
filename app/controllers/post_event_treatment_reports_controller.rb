class PostEventTreatmentReportsController < ApplicationController

  load_and_authorize_resource :plan
  load_and_authorize_resource :post_event_treatment_report, through: :plan, singleton: true
    
  def show
    unless @post_event_treatment_report
      @post_event_treatment_report = @plan.create_post_event_treatment_report
    end
  end
  
  def update
    if @post_event_treatment_report.update(post_event_treatment_report_params)
      redirect_to action: :show
    else
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
      result.merge(submitted: true,
                   creator: current_user)
      
    end
    result
  end
  
end
