FactoryBot.define do
  factory :volunteer, class: "Volunteer", parent: :user do
    transient do
      case_count { 0 }
      contacts_per_case { 0 }
      supervisor { nil }
    end

    type { "Volunteer" }

    case_assignments do
      Array.new(case_count) { association(:case_assignment, volunteer: instance, casa_org: instance.casa_org) }
    end

    supervisor_volunteer do
      association(:supervisor_volunteer, volunteer: instance, supervisor:, casa_org: instance.casa_org) if supervisor
    end

    trait :inactive do
      active { false }
    end

    trait :with_casa_cases do
      case_count { 2 }
    end

    trait :with_single_case do
      case_count { 1 }
    end

    trait :with_case_contacts do
      case_contacts do
        case_assignments.map { |ca|
          Array.new(contacts_per_case) { association(:case_contact, creator: ca.volunteer, casa_case: ca.casa_case) }
        }.flatten
      end
    end

    trait :with_case_contact do
      case_count { 1 }
      contacts_per_case { 1 }
      with_case_contacts
    end

    trait :with_case_contact_wants_driving_reimbursement do
      case_count { 1 }
      contacts_per_case { 1 }
      case_contacts do
        case_assignments.map { |ca|
          Array.new(contacts_per_case) { association(:case_contact, :wants_reimbursement, creator: ca.volunteer, casa_case: ca.casa_case) }
        }.flatten
      end
    end

    trait :with_pretransition_age_case do
      case_count { 1 }
      case_assignments do
        Array.new(case_count) { association(:case_assignment, :pre_transition, volunteer: instance, casa_org: instance.casa_org) }
      end
    end

    trait :with_cases_and_contacts do
      after(:create) do |user, _|
        assignment1 = create :case_assignment, casa_case: create(:casa_case, :pre_transition, casa_org: user.casa_org), volunteer: user
        create :case_assignment, casa_case: create(:casa_case, casa_org: user.casa_org, birth_month_year_youth: 10.years.ago), volunteer: user
        create :case_assignment, casa_case: create(:casa_case, casa_org: user.casa_org, birth_month_year_youth: 15.years.ago), volunteer: user
        contact = create :case_contact, creator: user, casa_case: assignment1.casa_case
        contact_types = create_list :contact_type, 3, contact_type_group: create(:contact_type_group, casa_org: user.casa_org)
        3.times do
          CaseContactContactType.create(case_contact: contact, contact_type: contact_types.pop)
        end
      end
    end

    trait :with_assigned_supervisor do
      transient do
        supervisor { association(:supervisor, casa_org: casa_org) }
      end
    end

    trait :with_disallow_reimbursement do
      after(:create) do |user, _|
        create(:case_assignment, :disallow_reimbursement, casa_case: create(:casa_case, casa_org: user.casa_org), volunteer: user)
      end
    end
  end
end
