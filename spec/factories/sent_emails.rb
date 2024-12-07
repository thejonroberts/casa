FactoryBot.define do
  factory :sent_email do
<<<<<<< Updated upstream
    association :user, factory: :user
    casa_org { CasaOrg.first || create(:casa_org) }
||||||| Stash base
    association :user
    casa_org { CasaOrg.first || create(:casa_org) }
=======
    user
    casa_org { user.casa_org }
>>>>>>> Stashed changes
    mailer_type { "Mailer Type" }
    category { "Mail Action Category" }
    sent_address { user.email }
  end
end
