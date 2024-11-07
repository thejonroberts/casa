FactoryBot.define do
  factory :user_reminder_time do
    user { association :volunteer }

    trait :case_contact_types do
      case_contact_types { DateTime.now }
    end
  end
end
