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

require 'rails_helper'

RSpec.describe TransportationRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
