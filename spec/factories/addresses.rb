FactoryBot.define do
  factory :address do
    content { Faker::Address.full_address }
    user { association :user }
  end
end
