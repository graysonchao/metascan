require 'pry'
require 'webmock/rspec'
require 'json'
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'metascan'

WebMock.disable_net_connect!(allow_localhost: true)

response_stubs = {
  :scan_file => JSON.dump({
    "rest_ip" => Metascan::PATHS[:scan_file],
    "data_id" => "sample_data_id",
    "progress_percentage" => 100
  }),

  :results_by_data_id => JSON.dump({
    "file_id" => "sample_file_id",
    "scan_results" => {
      "scan_all_result_i" => 0,
      "progress_percentage" => 100
    }
  }),

  :results_by_file_hash => JSON.dump({
    "file_id" => "sample_file_id",
    "scan_results" => {
      "scan_all_result_i" => 0,
      "progress_percentage" => 100
    }
  })
}

RSpec.configure do |cfg|
  cfg.before(:each) do
    stub_request(:post, Metascan::PATHS[:scan_file]).
      to_return(:status => 200, :body => response_stubs[:scan_file], :headers => {})
    stub_request(:get, "#{Metascan::PATHS[:results_by_data_id]}/sample_data_id").
      to_return(status: 200, body: response_stubs[:results_by_data_id], headers: {})
    stub_request(:get, Metascan::PATHS[:results_by_file_hash]).
      to_return(status: 200, body: response_stubs[:results_by_file_hash], headers: {})
  end

  cfg.expect_with :rspec do |c|
    # ...explicitly enable both
    c.syntax = [:should, :expect]
  end

end

# switch between returning dirty and clean scans
def switch_scan_dirt(dirt)
  if dirt
    dirty_response = JSON.dump({
      "file_id" => "sample_file_id",
      "scan_results" => {
        "scan_all_result_i" => 1,
        "progress_percentage" => 100
      },
    })
    stub_request(:get, "#{Metascan::PATHS[:results_by_data_id]}/sample_data_id").
      to_return(status: 200, body: dirty_response, headers: {})
  else
    clean_response = JSON.dump({
      "file_id" => "sample_file_id",
      "scan_results" => {
        "scan_all_result_i" => 0,
        "progress_percentage" => 100
      }
    })
    stub_request(:get, "#{Metascan::PATHS[:results_by_data_id]}/sample_data_id").
      to_return(status: 200, body: clean_response, headers: {})
  end
end
