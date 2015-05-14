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

FactoryGirl.define do
  factory :permitter do
    name "MyString"
phone_number "MyString"
address "MyText"
  end

end
