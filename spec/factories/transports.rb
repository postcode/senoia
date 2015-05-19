# == Schema Information
#
# Table name: transports
#
#  id          :integer          not null, primary key
#  name        :string
#  level       :string
#  provider_id :integer
#  lat         :decimal(10, 6)
#  lng         :decimal(10, 6)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :transport do
    name "MyString"
level "MyString"
provider_id 1
  end

end