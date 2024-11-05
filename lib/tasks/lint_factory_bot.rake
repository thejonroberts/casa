namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    if Rails.env.test?
      puts "linting factory_bot factories for being rails valid objects"
      conn = ActiveRecord::Base.connection
      conn.transaction do
        FactoryBot.lint FactoryBot.factories, traits: true
        raise ActiveRecord::Rollback
      end
    else
      system("bundle exec rake factory_bot:lint RAILS_ENV='test'")
      raise if $?.exitstatus.nonzero?
    end
  end
end
