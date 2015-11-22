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
#  email        :text
#

class Permitter < ActiveRecord::Base
  has_many :users, through: :permitters_users
  has_many :plans

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
end
