FactoryBot.define do
  factory :user do
    casa_org { CasaOrg.first || create(:casa_org) }
    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:display_name) { |n| "User #{n}" }
    password { "12345678" }
    password_confirmation { "12345678" }
    date_of_birth { nil }
    case_assignments { [] }
    phone_number { "" }
    confirmed_at { Time.now }
    token { "verysecuretoken" }

    trait :inactive do
      type { "Volunteer" }
      active { false }
      role { :inactive }
    end
  end
end
