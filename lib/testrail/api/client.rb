# TestRail API binding for Ruby (API v2, available since TestRail 3.0)
# http://docs.gurock.com/testrail-api2/start
# http://docs.gurock.com/testrail-api2/accessing

module Testrail
  module Api
    class Testrail::Api::Client
      API_PREFIX = "/index.php?/api/v2".freeze
      DEFAULT_HEADERS = {
        "Content-Type": "application/json"
      }

      def initialize(configuration:)
        @connection = Faraday.new(url: configuration.project_url, headers: DEFAULT_HEADERS) do |conn|
          conn.request(:authorization, :basic, configuration.username, configuration.password)
          conn.use(Faraday::Response::RaiseError)
        end
      end

      def get_resource(resource_name, resource_ids:, payload: nil)
        url = ["get_#{resource_name}", *resource_ids].join("/")

        do_request(method: :get, url: url, payload: payload)
      end

      def add_resource(resource_name, resource_ids:, payload:)
        url = ["add_#{resource_name}", *resource_ids].join("/")

        do_request(method: :post, url: url, payload: payload)
      end

      private

      def do_request(method:, url:, payload: nil)
        path = [API_PREFIX, url].join("/").delete_suffix("/")

        handler = {
          get: -> { @connection.get(path, payload) },
          post: -> { @connection.post(path, JSON.dump(payload)) }
        }.fetch(method, proc {})

        handler.call.then { |response| JSON.parse(response.body) }
      end
    end
  end
end
