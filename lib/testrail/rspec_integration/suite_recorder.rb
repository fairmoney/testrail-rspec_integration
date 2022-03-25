module Testrail
  module RspecIntegration
    class SuiteRecorder
      def initialize(configuration: Testrail::Api::Configuration.new)
        @configuration = configuration

        yield @configuration
      end

      def call(example)
        return unless @configuration.upload_results

        Testrail::RspecIntegration::ExampleHandler.new(
          configuration: @configuration,
          example: example
        ).call
      end
    end
  end
end
