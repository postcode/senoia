# == Schema Information
#
# Table name: organization_users
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contact         :boolean          default(TRUE)
#

class OrganizationUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  validates :user, presence: true
  validates :organization, presence: true
end
