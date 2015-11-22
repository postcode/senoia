# == Schema Information
#
# Table name: post_event_treatment_reports
#
#  id                                       :integer          not null, primary key
#  plan_id                                  :integer
#  creator_id                               :integer
#  actual_crowd_size                        :integer
#  resource_differences                     :text
#  medical_resource_sufficiency             :string
#  medical_resource_sufficiency_explanation :text
#  other_comments                           :text
#  submitted                                :boolean
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#

require 'rails_helper'

RSpec.describe PostEventTreatmentReport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
