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
  has_many :users, through: :providers_users
end
