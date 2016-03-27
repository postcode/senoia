# == Schema Information
#
# Table name: notification_group_memberships
#
#  id                    :integer          not null, primary key
#  notification_group_id :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe NotificationGroupMembership, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
