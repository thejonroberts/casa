FactoryBot.define do
  factory :patch_note_group do
    # real world values drop the +n
    # that is a uniqueness constraint workaround here
    sequence(:value) do |n|
      "CasaAdmin+Supervisor+Volunteer+#{n.to_s}"
    end
    # old trait, now default behavior; this avoids changing a lot of spec setups
    trait(:all_users) { }

    trait :only_supervisors_and_admins do
      sequence(:value) { |n| "CasaAdmin+Supervisor+#{n.to_s}" }
    end

    trait :no_users do
      sequence(:value) { |n| n.to_s }
    end
  end
end
