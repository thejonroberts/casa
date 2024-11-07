FactoryBot.define do
  factory :login_activity do
    association :user
    scope { "user" }
    strategy { "database_authenticatable" }
    identity { user.email }
    success { true }
    add_attribute(:context) { "session" } # disambiguate from RSpec#context
    ip { "127.0.0.1" }
    user_agent { "Mozilla/5.0 (Macintosh; Intel Mac OS X)" }
  end
end
