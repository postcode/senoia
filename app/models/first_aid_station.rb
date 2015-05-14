# == Schema Information
#
# Table name: first_aid_stations
#
#  id          :integer          not null, primary key
#  name        :string
#  md          :integer
#  rn          :integer
#  emt         :integer
#  aed         :integer
#  level       :string
#  provider_id :integer
#  lat         :decimal(10, 6)
#  lng         :decimal(10, 6)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FirstAidStation < ActiveRecord::Base
  has_many :users, through: :first_aid_stations_users
  belongs_to :provider
end
