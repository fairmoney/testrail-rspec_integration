# frozen_string_literal: true

require_relative "rspec_integration/example_handler"
require_relative "rspec_integration/suite_recorder"
require_relative "rspec_integration/version"
require_relative "api/configuration"
require_relative "api/client"

require "faraday"
require "json"

module Testrail
  module RspecIntegration
  end
end
