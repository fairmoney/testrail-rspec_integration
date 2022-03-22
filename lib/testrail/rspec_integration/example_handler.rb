module Testrail
  module RspecIntegration
    class ExampleHandler
      SUITE_ID_KEY_NAME = :testrail_suite_id
      CASE_IDS_KEY_NAME = :testrail_case_ids

      TEST_STATUSES = {
        passed: 1,
        blocked: 2,
        untested: 3,
        retest: 4,
        failed: 5
      }

      def initialize(configuration:, example:)
        @configuration = configuration
        @example = example
        @client = Testrail::Api::Client.new(configuration: configuration)
      end

      def call
        run = find_or_create_run

        case_ids.each do |case_id|
          @client.add_resource(
            "result_for_case",
            resource_ids: [run["id"], case_id],
            payload: {status_id: status_id}
          )
        end
      end

      private

      def status_id
        return TEST_STATUSES[:failed] if @example.exception && !@example.exception.message.include?("pending")
        return TEST_STATUSES[:blocked] if @example.skipped?
        return TEST_STATUSES[:blocked] if @example.pending?

        TEST_STATUSES[:passed]
      end

      def find_or_create_run
        return create_run if pending_runs.empty?

        pending_runs.first
      end

      def create_run
        @client.add_resource(
          "run",
          resource_ids: [@configuration.project_id],
          payload: {suite_id: current_suite_id, name: @configuration.run_name}
        )
      end

      def pending_runs
        @pending_runs ||= @client
          .get_resource(
            "runs",
            resource_ids: [@configuration.project_id],
            payload: {
              suite_id: current_suite_id,
              is_completed: 0
            }
          )
          .fetch("runs", [])
          .select { |run| run["name"] == @configuration.run_name }
      end

      def current_suite_id
        @example.example_group.metadata[SUITE_ID_KEY_NAME] || @configuration.suite_id
      end

      def case_ids
        @example.metadata[CASE_IDS_KEY_NAME]
      end
    end
  end
end
