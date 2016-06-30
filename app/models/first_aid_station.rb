# == Schema Information
#
# Table name: first_aid_stations
#
#  id                     :integer          not null, primary key
#  name                   :string
#  md                     :integer
#  rn                     :integer
#  emt                    :integer
#  aed                    :integer
#  level                  :string
#  organization_id        :integer
#  lat                    :decimal(10, 6)
#  lng                    :decimal(10, 6)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  operation_period_id    :integer
#  contact_name           :string
#  contact_phone          :string
#  location               :text
#  service_area           :text
#  planning_contact_email :string
#

class FirstAidStation < ActiveRecord::Base
  include MedicalAsset

  has_many :asset_communications
  has_many :communications, through: :asset_communications
end
