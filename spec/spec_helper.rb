require 'webmock/rspec'
require 'json'

WebMock.disable_net_connect!(allow_localhost: true)

response_stubs = {
  :scan_file => JSON.dump({
    "data_id" => "sample_data_id"
  }),

  :results_by_data_id => JSON.dump({
    "file_id" => "sample_file_id",
    "scan_results" => {
      "scan_all_result_i" => 0
    }
  }),

  :results_by_file_hash => JSON.dump({
    "file_id" => "sample_file_id",
    "scan_results" => {
      "scan_all_result_i" => 0
    }
  })
}

RSpec.configure do |cfg|
  cfg.before(:each) do
    stub_request(:post, Metascan::PATHS[:scan_file]).
      to_return(:status => 200, :body => response_stubs[:scan_file], :headers => {})
    stub_request(:get, "#{Metascan::PATHS[:results_by_data_id]}sample_data_id").
      to_return(status: 200, body: response_stubs[:results_by_data_id], headers: {})
    stub_request(:get, Metascan::PATHS[:results_by_file_hash]).
      to_return(status: 200, body: response_stubs[:results_by_file_hash], headers: {})
  end
end
