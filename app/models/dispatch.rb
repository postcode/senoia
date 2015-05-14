# == Schema Information
#
# Table name: dispatches
#
#  id          :integer          not null, primary key
#  name        :string
#  level       :string
#  provider_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Dispatch < ActiveRecord::Base
  has_many :users, through: :dispatchs_users
  belongs_to :provider
end
