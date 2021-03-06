# == Schema Information
#
# Table name: mobile_teams
#
#  id                     :integer          not null, primary key
#  level                  :string
#  aed                    :integer
#  organization_id        :integer
#  name                   :string
#  lat                    :decimal(10, 6)
#  lng                    :decimal(10, 6)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  operation_period_id    :integer
#  contact_name           :string
#  contact_phone          :string
#  location               :text
#  mobile_team_type       :string
#  service_area           :text
#  planning_contact_email :string
#

class MobileTeam < ActiveRecord::Base
  include MedicalAsset
  has_many :asset_communications
  has_many :communications, through: :asset_communications

  LEVELS =  ["ALS", "BLS", "Non-Medical"]
  TEAM_TYPES = ["Foot", "Bike", "Gator/Cart", "Sag Wagon", "Boat-based", "Personal Water Craft", "Kayak"]
end
