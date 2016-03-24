class NotificationGroup < ActiveRecord::Base
  has_many :notification_group_memberships, inverse_of: :notification_group, dependent: :destroy
  has_many :members, through: :notification_group_memberships, source: :user

  accepts_nested_attributes_for :notification_group_memberships, allow_destroy: true
  
  def to_s
    name
  end
end
