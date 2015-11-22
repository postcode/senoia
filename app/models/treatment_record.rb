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

class TreatmentRecord < ActiveRecord::Base
  belongs_to :post_event_treatment_report, inverse_of: :treatment_records
end
