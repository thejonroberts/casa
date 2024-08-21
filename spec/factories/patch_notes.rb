FactoryBot.define do
  factory :patch_note do
    sequence(:note, "a") # "a".next is "b", and so on...
    patch_note_type
    patch_note_group

    trait :only_supervisors_and_admins do
      association :patch_note_group, :only_supervisors_and_admins
    end

    trait :no_user_groups do
      association :patch_note_group, :no_users
    end
  end
end
