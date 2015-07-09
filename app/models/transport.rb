# == Schema Information
#
# Table name: transports
#
#  id                  :integer          not null, primary key
#  name                :string
#  level               :string
#  provider_id         :integer
#  lat                 :decimal(10, 6)
#  lng                 :decimal(10, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  operation_period_id :integer
#  contact_name        :string
#  contact_phone       :string
#

class Transport < ActiveRecord::Base
  has_many :users, through: :transports_users
  belongs_to :provider
end
