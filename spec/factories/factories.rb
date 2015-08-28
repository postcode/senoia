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

    factory :plan_awaiting_review do
      workflow_state :awaiting_review
    end
  end

  factory :comment do
    body { Faker::Lorem.paragraph }
    user

    factory :comment_on_event_type do
      element_id "event_type_comment_text"
    end
  end

  factory :admin, :class => User do |u|
    u.email { Faker::Internet.email }
    u.password "password"
    u.password_confirmation "password"
    u.roles 'admin'
    u.confirmed_at Date.today
  end
end
