# == Schema Information
#
# Table name: operation_periods
#
#  id         :integer          not null, primary key
#  start_date :datetime
#  end_date   :datetime
#  attendance :integer
#  plan_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :operation_period do
    start_date "2015-05-13 18:18:11"
end_date "2015-05-13 18:18:11"
attendance 1
plan_id 1
  end

end
