ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    fixtures :all

    def assert_datetime(expected, actual)
      assert_in_delta expected, Time.zone.parse(actual), 1
    end
  end
end
