class FirstAidStation < ActiveRecord::Base
  has_many :users, through: :first_aid_stations_users
  belongs_to :provider
end
