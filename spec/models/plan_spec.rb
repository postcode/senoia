# == Schema Information
#
# Table name: plans
#
#  id                                :integer          not null, primary key
#  name                              :string
#  owner_id                          :integer
#  alcohol                           :boolean
#  created_at                        :datetime
#  updated_at                        :datetime
#  event_type_id                     :integer
#  organization_id                   :integer
#  workflow_state                    :string
#  event_contact                     :text
#  responsibility                    :boolean
#  cpr                               :boolean
#  communication                     :boolean
#  post_event_name                   :string
#  post_event_email                  :string
#  post_event_phone                  :string
#  creator_id                        :integer
#  venue_id                          :integer
#  communication_phone               :string
#  staff_responsibility              :boolean
#  mci                               :boolean          default(FALSE)
#  approval_date                     :datetime
#  staff_responsibility_reminder_1wk :boolean
#  staff_responsibility_reminder_2wk :boolean
#

require 'rails_helper'

RSpec.describe Plan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
