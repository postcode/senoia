class TransportationRecordsController < ApplicationController
  before_action :find_plan

  def new
    authorize! :edit, @plan
    @transportation_record = @post_event_treatment_report.transportation_records.build
  end

  def edit
  end

  def update
  end

  def create
    authorize! :edit, @plan
    d = Time.strptime(params[:transportation_record][:transported_at], "%m/%d/%Y %l:%M %P").in_time_zone
    @transportation_record = @post_event_treatment_report.transportation_records.create(transportation_record_params)
    @transportation_record.transported_at = DateTime.new(d.getutc.year, d.getutc.month, d.getutc.day, d.hour, d.min)
    @transportation_record.save!
  end

  def destroy
    authorize! :edit, @plan
    @transportation_record.destroy
  end

  private

   def find_plan
    @plan = Plan.find(params[:plan_id])
    @post_event_treatment_report = @plan.post_event_treatment_report
  end

  def transportation_record_params
    params.require(:transportation_record)
      .permit(:chief_complaint,
              :transport_id,
              :destination,
              :transported_at)
  end

end
