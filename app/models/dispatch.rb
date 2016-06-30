# == Schema Information
#
# Table name: dispatches
#
#  id                     :integer          not null, primary key
#  name                   :string
#  level                  :string
#  organization_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  operation_period_id    :integer
#  contact_name           :string
#  contact_phone          :string
#  location               :text
#  lat                    :decimal(10, 6)
#  lng                    :decimal(10, 6)
#  service_area           :text
#  planning_contact_email :string
#

class Dispatch < ActiveRecord::Base
  include MedicalAsset
  
  has_many :asset_communications
  has_many :communications, through: :asset_communications
end
