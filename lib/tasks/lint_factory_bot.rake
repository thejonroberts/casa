namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    if Rails.env.test?
      puts "linting factory_bot factories for being rails valid objects"
      conn = ActiveRecord::Base.connection
      # HERE THERE BE DRAGONS
      raise "a suspiciously low number of FactoryBot factories" if FactoryBot.factories.count < 50
      factories_to_lint = FactoryBot.factories.reject do |factory|
        # todo: remove this.
        invalid_factories.include?(factory.name)
      end
      conn.transaction do
        FactoryBot.lint(factories_to_lint, traits: true)
        raise ActiveRecord::Rollback
      end
    else
      system("bundle exec rake factory_bot:lint RAILS_ENV='test'")
      raise if $?.exitstatus.nonzero?
    end
  end
end
