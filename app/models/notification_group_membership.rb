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

class NotificationGroupMembership < ActiveRecord::Base
  belongs_to :notification_group, inverse_of: :notification_group_memberships
  belongs_to :user, inverse_of: :notification_group_memberships

  validates :notification_group, presence: true
  validates :user, presence: true, uniqueness: { scope: :notification_group }
end
