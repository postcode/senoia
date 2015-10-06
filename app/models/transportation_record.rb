class TransportationRecord < ActiveRecord::Base
  belongs_to :post_event_treatment_report, inverse_of: :transportation_records
  belongs_to :transport

  include CustomDateTimeFormat
  use_custom_datetime_format_for :transported_at

end
