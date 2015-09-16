# == Schema Information
#
# Table name: providers
#
#  id           :integer          not null, primary key
#  name         :string
#  phone_number :string
#  address      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Provider < ActiveRecord::Base
  has_many :providers_users
  has_many :users, through: :providers_users
  has_many :contact_users, -> { where("providers_users.contact" => true) }, source: :user, through: :providers_users
  
  has_many :first_aid_stations
  has_many :dispatchs
  has_many :transports
  has_many :mobile_teams
  has_many :provider_confirmations

  def to_s
    name
  end
end
