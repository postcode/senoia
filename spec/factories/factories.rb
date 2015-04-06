FactoryGirl.define do
 factory :user do
    name Faker::Name.name
  end

  factory :plan do
    name Faker::Lorem.word
  end
end