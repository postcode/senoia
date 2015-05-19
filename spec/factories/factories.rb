FactoryGirl.define do
 factory :user do
    email { Faker::Internet.email }
    first_name Faker::Name.name
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
  end

  factory :plan do
    name Faker::Lorem.word
  end

  factory :admin, :class => User do |u|
    u.email { Faker::Internet.email }
    u.password "password"
    u.password_confirmation "password"
    u.roles 'admin'
    u.confirmed_at Date.today
  end
end