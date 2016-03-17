# == Schema Information
#
# Table name: organizations
#
#  id                   :integer          not null, primary key
#  name                 :string
#  address              :string
#  email                :string
#  phone_number         :string
#  organization_type_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Organization < ActiveRecord::Base
  has_many :organization_users
  has_many :users, through: :organization_users
  has_one :organization_type

  validates :name, presence: true
end
