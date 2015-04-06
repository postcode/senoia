# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string
#  owner_id   :integer
#  start_date :datetime
#  end_date   :datetime
#  attendance :integer
#  event_type :integer
#  alcohol    :boolean
#

class Plan < ActiveRecord::Base
  belongs_to :owner, class_name: User
end
