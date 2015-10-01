class PostEventTreatmentReport < ActiveRecord::Base
  belongs_to :plan
  belongs_to :creator, class_name: "User"

  has_many :supplementary_documents, as: :parent
  has_many :transportation_records, inverse_of: :post_event_treatment_report
  has_many :treatment_records, inverse_of: :post_event_treatment_report
  
  VALID_MEDICAL_RESOURCE_SUFFICIENCY_OPTIONS = [ "too_few", "too_many", "appropriate" ]
  validates :medical_resource_sufficiency, inclusion: VALID_MEDICAL_RESOURCE_SUFFICIENCY_OPTIONS, allow_blank: true

  validates :plan, presence: true
  
  delegate :event_type, :start_date, :end_date, :attendance, to: :plan
  
end
