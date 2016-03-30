# == Schema Information
#
# Table name: transportation_records
#
#  id                             :integer          not null, primary key
#  post_event_treatment_report_id :integer
#  chief_complaint                :text
#  transport_id                   :integer
#  destination                    :text
#  transported_at                 :datetime
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class TransportationRecord < ActiveRecord::Base
  belongs_to :post_event_treatment_report, inverse_of: :transportation_records
  belongs_to :transport

  include CustomDateTimeFormat
  use_custom_datetime_format_for :transported_at

  def formatted_date
    if transported_at.present?
      DateTime.new(transported_at.getutc.year, transported_at.getutc.month, transported_at.getutc.day, transported_at.hour, transported_at.min)
    end
  end

end
