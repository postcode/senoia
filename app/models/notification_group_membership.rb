class NotificationGroupMembership < ActiveRecord::Base
  belongs_to :notification_group, inverse_of: :notification_group_memberships
  belongs_to :user, inverse_of: :notification_group_memberships

  validates :notification_group, presence: true
  validates :user, presence: true, uniqueness: { scope: :notification_group }
end
