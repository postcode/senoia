class TreatmentRecord < ActiveRecord::Base
  belongs_to :post_event_treatment_report, inverse_of: :treatment_records
end
