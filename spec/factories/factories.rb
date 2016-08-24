FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name Faker::Name.name
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    roles "guest"

    factory :medical_contact do
      after(:create) do |user, evaluator|
        provider = create(:provider)
        provider.contact_users << user
      end
    end

    factory :admin do
      roles "admin"
    end

    factory :promoter_user do
      roles "promoter"
    end

  end

  factory :operation_period do
    start_date DateTime.now
    start_time Time.current
    end_date   DateTime.now + 1.day
    end_time   Time.current
    attendance Faker::Number.number(5)

    factory :past do
      start_date 10.days.ago
      end_date 9.days.ago
    end

    factory :in_next_week do
      start_date 5.days.from_now
      end_date 6.days.from_now
    end

    factory :in_next_two_weeks do
      start_date 12.days.from_now
      end_date 13.days.from_now
    end

    factory :far_out do
      start_date 30.days.from_now
      end_date 31.days.from_now
    end
  end

  factory :plan do
    name { Faker::Lorem.words(3).join }
    event_type
    operation_periods { [FactoryGirl.create(:operation_period)] }
    organization { FactoryGirl.create(:permitter) }
    creator { FactoryGirl.create(:promoter_user) }

    factory :plan_under_review do
      workflow_state :under_review
    end

    factory :draft do
      workflow_state :draft
    end

    factory :plan_requiring_revision do
      workflow_state :revision_requested
    end

    trait :approved do
      workflow_state :approved
      approval_date Time.now
    end

    factory :approved_plan do
      approved
    end

    factory :no_operation_period do
      operation_periods []
    end

    factory :far_out_ops do
      approved
      operation_periods { [FactoryGirl.create(:far_out)] }
    end

    factory :past_op do
      approved
      operation_periods { [FactoryGirl.create(:past)] }
    end

    trait :op_within_two_weeks do
      operation_periods { [FactoryGirl.create(:in_next_two_weeks)] }
    end

    factory :op_within_two_weeks_unapproved do
      op_within_two_weeks
    end

    factory :op_within_two_weeks_approved do
      approved
      op_within_two_weeks
    end

    trait :op_within_week do
      operation_periods { [FactoryGirl.create(:in_next_week)] }
    end

    factory :op_within_week_approved do
      # Let's say we've already sent the 2 week reminder.
      staff_responsibility_reminder_2wk true

      approved
      op_within_week
    end
  end

  factory :plan_user do
    plan
    user
    role "view"
  end

  factory :comment do
    body { Faker::Lorem.paragraph }
    commentable { FactoryGirl.create(:plan) }
    user

    factory :comment_on_event_type do
      element_id "event_type_comment_text"
    end
  end

  factory :first_aid_station do
    name Faker::Lorem.words(3).join(" ")
    organization { FactoryGirl.create(:organization) }
  end

  factory :mobile_team do
    name Faker::Lorem.words(3).join(" ")
    organization { FactoryGirl.create(:organization) }
  end

  factory :transport do
    name Faker::Lorem.words(3).join(" ")
    organization { FactoryGirl.create(:organization) }
  end

  factory :dispatch do
    name Faker::Lorem.words(3).join(" ")
    organization { FactoryGirl.create(:organization) }
  end

  factory :event_type do
    name { Faker::Lorem.words(3).join(" ") }

    factory :concert do
      name "Concert or Music Festival"
    end

    factory :sports do
      name "Athletic or Sporting Event"
    end
  end

  factory :supplementary_document do
    parent { plan }
    name { Faker::Lorem.words(3).join(" ") }
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'README.rdoc')) }
    email true
  end

  factory :notification_group do
    name { Faker::Lorem.words(3).join(" ") }
    notification_type "plan.approved"
  end

  factory :organization_type do
    description { Faker::Lorem.paragraph }

    factory :permitter_type do
      name "Event Permitter"
    end

    factory :promoter_type do
      name "Event Producer"
    end

    factory :provider_type do
      name "EMS Provider"
    end
  end

  factory :organization do
    name { Faker::Lorem.words(3).join(" ") }
    phone_number { PhonyRails.normalize_number(Faker::PhoneNumber.phone_number) }
    address { [Faker::Address.street_address, Faker::Address.city, Faker::Address.zip, Faker::Address.state].join("\n") }
    email { Faker::Internet.email }
    organization_type

    factory :permitter do
      organization_type { FactoryGirl.create(:permitter_type) }
    end

    factory :promoter do
      organization_type { FactoryGirl.create(:promoter_type) }
    end

    factory :provider do
      organization_type { FactoryGirl.create(:provider_type) }
    end
  end

  factory :organization_user do
    user
    organization
    contact true
  end
end
