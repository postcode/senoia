# == Schema Information
#
# Table name: plan_users
#
#  id      :integer          not null, primary key
#  user_id :integer
#  plan_id :integer
#  role    :string
#

class PlanUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  ROLES = %w(view edit)

  validates :user, presence: true
  validates :plan, presence: true
  validates :role, presence: true, inclusion: ROLES
end
