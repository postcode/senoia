# == Schema Information
#
# Table name: mobile_teams
#
#  id                  :integer          not null, primary key
#  level               :string
#  type                :string
#  aed                 :integer
#  provider_id         :integer
#  name                :string
#  lat                 :decimal(10, 6)
#  lng                 :decimal(10, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  operation_period_id :integer
#  contact_name        :string
#  contact_phone       :string
#

class MobileTeam < ActiveRecord::Base
  has_many :users, through: :mobile_teams_users
  belongs_to :provider
end
