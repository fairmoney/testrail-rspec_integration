module Testrail
  module RspecIntegration
    class SuiteRecorder
      def initialize(configuration: Testrail::Api::Configuration.new)
        @configuration = configuration

        yield @configuration
      end

      def call(example)
        if @configuration.allow || @configuration.allow == "true"
          Testrail::RspecIntegration::ExampleHandler.new(
            configuration: @configuration,
            example: example
          ).call
        end
      end
    end
  end
end
