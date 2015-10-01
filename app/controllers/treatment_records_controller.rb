class TreatmentRecordsController < ApplicationController

  load_and_authorize_resource :plan, except: [ :destroy ]
  load_and_authorize_resource :post_event_treatment_report, through: :plan, singleton: true, except: [ :destroy ]
  load_and_authorize_resource :treatment_record, through: :post_event_treatment_report, except: [ :destroy ]
  load_and_authorize_resource :treatment_record, only: [ :destroy ]

  def new
    @treatment_record = @post_event_treatment_report.treatment_records.build
  end
  
  def edit
  end
  
  def update
  end
  
  def create
    @treatment_record = @post_event_treatment_report.treatment_records.create(treatment_record_params)
  end
  
  def destroy
    @treatment_record.destroy
  end
  
  private
  
  def treatment_record_params
    params.require(:treatment_record)
      .permit(:problem_description,
              :persons_count,
              :treatment,
              :outcome)
  end
  
end
