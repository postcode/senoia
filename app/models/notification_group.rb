# == Schema Information
#
# Table name: notification_groups
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  notification_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class NotificationGroup < ActiveRecord::Base
  has_many :notification_group_memberships, inverse_of: :notification_group, dependent: :destroy
  has_many :members, through: :notification_group_memberships, source: :user

  accepts_nested_attributes_for :notification_group_memberships, allow_destroy: true
  
  def to_s
    name
  end
end
