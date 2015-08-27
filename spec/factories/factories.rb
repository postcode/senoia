FactoryGirl.define do
 factory :user do
    email { Faker::Internet.email }
    first_name Faker::Name.name
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
  end
  
  factory :operation_period do
    start_date DateTime.now
    end_date   DateTime.now + 1.day
    attendance Faker::Number.number(5)     
  end

  factory :plan do
    name Faker::Lorem.word
    operation_periods = FactoryGirl.create(:operation_period)
  end

  factory :permitter do
    name { Faker::Lorem.words(3).join(" ") }
    phone_number { Faker::PhoneNumber.phone_number }
    address { [ Faker::Address.street_address, Faker::Address.city, Faker::Address.zip, Faker::Address.state ].join("\n") }
  end

  factory :admin, :class => User do |u|
    u.email { Faker::Internet.email }
    u.password "password"
    u.password_confirmation "password"
    u.roles 'admin'
    u.confirmed_at Date.today
  end
end
