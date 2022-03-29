# Testrail::RspecIntegration

Small gem for setting up the integration between rspec tests and [Testrail](https://www.gurock.com/testrail/docs/api/getting-started/introduction/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'testrail-rspec_integration'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install testrail-rspec_integration

## Usage

Define RSpec configuration

```ruby
RSpec.configure do |config|
  config.add_setting :testrail_recorder

  config.before(:all) do
    git_sha = `git rev-parse HEAD`[0..9] # Or another unique value
    
    config.testrail_recorder = Testrail::RspecIntegration::SuiteRecorder.new do |recorder_config|
      recorder_config.project_url = "https://example.testrail.io"
      recorder_config.project_id = 42
      recorder_config.username = "testrail-user"
      recorder_config.password = "testrail-password"
      recorder_config.run_name = git_sha
      recorder_config.upload_results = true
    end
  end

  config.after(:example, testrail_case_ids: proc { |value| !value.empty? }) do |example|
    config.testrail_recorder.call(example)
  end

  config.after(:suite) do
    config.testrail_recorder.close_open_runs
  end

end
```

Set up suite id and case ids in your tests

```ruby
RSpec.describe "CustomArray", testrail_suite_id: 1337 do
  it "stores elements", testrail_case_ids: %w[C42 C52] do
    custom_array = CustomerArray.new
    custom_array.add(1)
    
    expect(custom_array.elements).to eq([1])
  end

  it "returns size", testrail_case_ids: %w[C62] do
    custom_array = CustomerArray.new
    custom_array.add(1)
    custom_array.add(2)

    expect(custom_array.size).to eq(2)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/testrail-rspec_integration.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

