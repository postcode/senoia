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
end
