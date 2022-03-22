RSpec.configure do |config|
  config.add_setting :testrail_recorder

  config.before(:all) do
    config.testrail_recorder = Testrail::RspecIntegration::SuiteRecorder.new do |recorder_config|
      recorder_config.project_url = "https://example.testrail.io"
      recorder_config.project_id = 42
      recorder_config.username = "testrail-user"
      recorder_config.password = "testrail-password"
      recorder_config.run_name = "My test run"
    end
  end

  config.after(:example, testrail_case_ids: proc { |value| !value.empty? }) do |example|
    config.testrail_recorder.call(example)
  end
end
