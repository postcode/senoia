class TreatmentRecordsController < ApplicationController
  before_action :find_plan

  def new
    authorize! :edit, @plan
    @treatment_record = @post_event_treatment_report.treatment_records.build
  end

  def edit
  end

  def update
  end

  def create
    authorize! :edit, @plan
    @treatment_record = @post_event_treatment_report.treatment_records.create(treatment_record_params)
  end

  def destroy
    authorize! :edit, @plan
    @treatment_record.destroy
  end

  private

  def find_plan
    @plan = Plan.find(params[:plan_id])
    @post_event_treatment_report = @plan.post_event_treatment_report
  end

  def treatment_record_params
    params.require(:treatment_record)
      .permit(:problem_description,
              :persons_count,
              :treatment,
              :outcome)
  end

end
