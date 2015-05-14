class Permitter < ActiveRecord::Base
  has_many :users, through: :permitters_users
  has_many :plans
end
