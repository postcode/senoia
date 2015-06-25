# == Schema Information
#
# Table name: first_aid_stations_users
#
#  id                  :integer          not null, primary key
#  first_aid_staion_id :integer
#  user_id             :integer
#  contact             :boolean
#

class FirstAidStationsUser < ActiveRecord::Base
  belongs_to :first_aid_station
  belongs_to :user
end
