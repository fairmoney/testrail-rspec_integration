RSpec.describe "Testrail example recorder", testrail_suite_id: 1337 do
  let(:headers) do
    {
      "Authorization" => "Basic dGVzdHJhaWwtdXNlcjp0ZXN0cmFpbC1wYXNzd29yZA==",
      "Content-Type" => "application/json"
    }
  end

  context "when run exists" do
    let(:runs) do
      {
        runs: [
          {id: 1, name: "My test run"},
          {id: 2, name: "Test 42"}
        ]
      }
    end

    before do
      stub_request(:get, "https://example.testrail.io/index.php?/api/v2/get_runs/42&is_completed=0&suite_id=1337")
        .with(headers: headers)
        .to_return(status: 200, body: JSON.generate(runs))

      stub_request(:post, "https://example.testrail.io/index.php?/api/v2/add_result_for_case/1/C42")
        .with(headers: headers, body: {status_id: 1})
        .to_return(status: 201, body: '{ "id": "C42" }')

      stub_request(:post, "https://example.testrail.io/index.php?/api/v2/add_result_for_case/1/C43")
        .with(headers: headers, body: {status_id: 2})
        .to_return(status: 201, body: '{ "id": "C43" }')
    end

    it "returns a result of calculation", testrail_case_ids: %w[C42] do
      expect(2 + 2).to eq(4)
    end

    it "returns a result of calculation", testrail_case_ids: %w[C43] do
      skip
      expect(2 * 2).to eq(4)
    end
  end

  context "when run does not exist" do
    let(:runs) do
      {
        runs: [
          {id: 42, name: "Test 42"}
        ]
      }
    end

    let(:new_run) do
      {id: "42", name: "My test run"}
    end

    before do
      stub_request(:get, "https://example.testrail.io/index.php?/api/v2/get_runs/42&is_completed=0&suite_id=1337")
        .with(headers: headers)
        .to_return(status: 200, body: JSON.generate(runs))

      stub_request(:post, "https://example.testrail.io/index.php?/api/v2/add_run/42")
        .with(headers: headers, body: {suite_id: 1337, name: "My test run"})
        .to_return(status: 200, body: JSON.generate(new_run), headers: {})

      stub_request(:post, "https://example.testrail.io/index.php?/api/v2/add_result_for_case/42/C42")
        .with(headers: headers, body: {status_id: 1})
        .to_return(status: 201, body: '{ "id": "C42" }')

      stub_request(:post, "https://example.testrail.io/index.php?/api/v2/add_result_for_case/42/C43")
        .with(headers: headers, body: {status_id: 2})
        .to_return(status: 201, body: '{ "id": "C43" }')
    end

    it "returns a result of calculation", testrail_case_ids: %w[C42] do
      expect(2 + 2).to eq(4)
    end

    it "returns a result of calculation", testrail_case_ids: %w[C43] do
      skip
      expect(2 * 2).to eq(4)
    end
  end
end
