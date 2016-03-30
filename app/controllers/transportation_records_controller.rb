class TransportationRecordsController < ApplicationController

  load_and_authorize_resource :plan, except: [ :destroy ]
  load_and_authorize_resource :post_event_treatment_report, through: :plan, singleton: true, except: [ :destroy ]
  load_and_authorize_resource :transportation_record, through: :post_event_treatment_report, except: [ :destroy ]
  load_and_authorize_resource :transportation_record, only: [ :destroy ]

  def new
    @transportation_record = @post_event_treatment_report.transportation_records.build
  end
  
  def edit
  end
  
  def update
  end
  
  def create
    d = Time.strptime(params[:transportation_record][:transported_at], "%m/%d/%Y %l:%M %P").in_time_zone
    @transportation_record = @post_event_treatment_report.transportation_records.create(transportation_record_params)
    @transportation_record.transported_at = DateTime.new(d.getutc.year, d.getutc.month, d.getutc.day, d.hour, d.min)
    @transportation_record.save!
  end
  
  def destroy
    @transportation_record.destroy
  end
  
  private
  
  def transportation_record_params
    params.require(:transportation_record)
      .permit(:chief_complaint,
              :transport_id,
              :destination,
              :transported_at)
  end
  
end
