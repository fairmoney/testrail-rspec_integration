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

      def close_open_runs
        return unless @configuration.upload_results

        Testrail::RspecIntegration::ExampleHandler.new(
          configuration: @configuration,
          example: nil
        ).close_runs
      end
    end
  end
end
