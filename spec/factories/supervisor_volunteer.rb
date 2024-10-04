FactoryBot.define do
  factory :supervisor_volunteer do
    transient do
      casa_org { CasaOrg.first || create(:casa_org) }
    end

    volunteer { association :volunteer, casa_org: }
    supervisor { association :supervisor, casa_org: }

    trait :inactive do
      is_active { false }
    end
  end
end
