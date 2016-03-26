# == Schema Information
#
# Table name: communications
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Communication < ActiveRecord::Base
  has_many :asset_communications
  has_many :first_aid_stations, through: :asset_communications
  has_many :mobile_teams, through: :asset_communications
  has_many :transports, through: :asset_communications
  has_many :dispatchs, through: :asset_communications
end
