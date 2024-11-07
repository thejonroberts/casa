FactoryBot.define do
  factory :banner do
    casa_org
    user { association :supervisor, casa_org: }
    name { "Volunteer Survey" }
    active { true }
    content { "Please fill out this survey" }
  end
end
