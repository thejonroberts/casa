# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?

require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!
require "pundit/rspec"
require "view_component/test_helpers"
require "capybara/rspec"
require "action_text/system_test_helper"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
Rails.root.glob("spec/support/**/*.rb").sort_by(&:to_s).each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include DatatableHelper, type: :datatable
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Organizational, type: :helper
  config.include Organizational, type: :view
  config.include PunditHelper, type: :view
  config.include SessionHelper, type: :view
  config.include SessionHelper, type: :request
  config.include TemplateHelper
  config.include Warden::Test::Helpers
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include ActionText::SystemTestHelper, type: :system
  config.include TwilioHelper, type: :request
  config.include TwilioHelper, type: :system

  config.before(:suite) do
    FactoryBot.reload
  end

  config.after do
    Warden.test_reset!
  end

  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [Rails.root.join("spec/fixtures")]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Auto detect datatable type specs
  config.define_derived_metadata(file_path: Regexp.new("/spec/datatables/")) do |metadata|
    metadata[:type] = :datatable
  end

  # Filter backtraces to gems that are not under our control.
  # Can override using `--backtrace` option to rspec to see full backtraces.
  config.filter_rails_from_backtrace!
  config.filter_gems_from_backtrace(*%w[
    bootsnap capybara factory_bot puma rack railties shoulda-matchers
    sprockets-rails pundit
  ])

  config.around do |example|
    # If timeout is not set it will run without a timeout
    Timeout.timeout(ENV["TEST_MAX_DURATION"].to_i) do
      example.run
    end
  rescue Timeout::Error
    raise StandardError.new "\"#{example.full_description}\" in #{example.location} timed out."
  end

  config.around :each, :disable_bullet do |example|
    Bullet.raise = false
    example.run
    Bullet.raise = true
  end

  def pre_transition_aged_youth_age
    Date.current - CasaCase::TRANSITION_AGE.years
  end

  config.around do |example|
    Capybara.server_port = 7654 + ENV["TEST_ENV_NUMBER"].to_i
    example.run
  end

  config.filter_run_excluding :ci_only unless ENV["GITHUB_ACTIONS"]
end

TestProf.configure do |config|
  # the directory to put artifacts (reports) in ('tmp/test_prof' by default)
  config.output_dir = "tmp/test_prof"

  # use unique filenames for reports (by simply appending current timestamp)
  config.timestamps = true

  # color output
  config.color = true

  # where to write logs (defaults)
  config.output = $stdout

  # alternatively, you can specify a custom logger instance
  # config.logger = MyLogger.new

  # config.include_variations = true
end
