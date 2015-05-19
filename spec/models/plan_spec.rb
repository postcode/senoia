# == Schema Information
#
# Table name: plans
#
#  id             :integer          not null, primary key
#  name           :string
#  owner_id       :integer
#  start_date     :datetime
#  end_date       :datetime
#  attendance     :integer
#  alcohol        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  event_type_id  :integer
#  permitter_id   :integer
#  workflow_state :string
#

require 'rails_helper'

RSpec.describe Plan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
