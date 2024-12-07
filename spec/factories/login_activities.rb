FactoryBot.define do
  factory :login_activity do
    user
    scope { "user" }
    strategy { "database_authenticatable" }
    identity { user.email }
    success { true }
<<<<<<< Updated upstream
    context { "session" }
||||||| Stash base
    context { "session" }

=======
    context { "session" } # rubocop:disable RSpec/EmptyExampleGroup, RSpec/MissingExampleGroupArgument

>>>>>>> Stashed changes
    ip { "127.0.0.1" }
    user_agent { "Mozilla/5.0 (Macintosh; Intel Mac OS X)" }
  end
end
