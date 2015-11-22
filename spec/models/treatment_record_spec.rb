# == Schema Information
#
# Table name: treatment_records
#
#  id                             :integer          not null, primary key
#  post_event_treatment_report_id :integer
#  problem_description            :text
#  persons_count                  :integer
#  treatment                      :text
#  outcome                        :text
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

require 'rails_helper'

RSpec.describe TreatmentRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
