# == Schema Information
#
# Table name: dispatches
#
#  id                  :integer          not null, primary key
#  name                :string
#  level               :string
#  provider_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  operation_period_id :integer
#  contact_name        :string
#  contact_phone       :string
#

class Dispatch < ActiveRecord::Base
  has_many :users, through: :dispatchs_users
  belongs_to :provider
end
