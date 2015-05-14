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

FactoryGirl.define do
  factory :dispatch do
    name "MyString"
level "MyString"
provider_id 1
  end

end
