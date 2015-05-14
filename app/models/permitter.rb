# == Schema Information
#
# Table name: permitters
#
#  id           :integer          not null, primary key
#  name         :string
#  phone_number :string
#  address      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Permitter < ActiveRecord::Base
  has_many :users, through: :permitters_users
  has_many :plans
end
