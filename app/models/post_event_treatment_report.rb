class PostEventTreatmentReport < ActiveRecord::Base
  belongs_to :plan
  belongs_to :creator

  VALID_MEDICAL_RESOURCE_SUFFICIENCY_OPTIONS = [ "too_few", "too_many", "appropriate" ]
  validates :medical_resource_sufficiency, inclusion: VALID_MEDICAL_RESOURCE_SUFFICIENCY_OPTIONS, allow_blank: true

  validates :plan, presence: true
  
  delegate :event_type, :start_date, :end_date, :attendance, to: :plan
  
end
