# frozen_string_literal: true

require "testrail/rspec_integration"

require "webmock/rspec"
require "simplecov"

require_relative "support/testrail_recorder"

::SimpleCov.start do
  enable_coverage :branch
  add_filter ".bundle"
  add_filter "vendor"
  add_filter "spec"
end

RSpec.configure do |config|
  WebMock.disable_net_connect!

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
