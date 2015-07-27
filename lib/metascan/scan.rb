module Metascan

  require 'typhoeus'
  require 'json'
  require 'uri'

  # A single scan on the Metascan service.
  # Initialized with the parameters to scan,
  # exposes methods to inspect the scan results.
  class Scan
    attr_reader :data_id
    attr_reader :filename

    def initialize(filename, client, archivepwd: nil)
      @filename   = filename
      @client     = client
      @archivepwd = archivepwd
    end

    # Initiate a scan of @filename
    def run
      self.request.run
    end

    # Construct and return the request I use, for the purpose of
    # queueing in a Typhoeus::Hydra.
    def request
      request = Typhoeus::Request.new(
        Metascan::PATHS[:scan_file],
        headers: {
          'filename' => @filename,
          'archivepwd' => @archivepwd,
          'apikey' => @client.api_key
        }.select { |k, v| !v.nil? },
        method: :post,
        body: { file: File.open(@filename, "r") }
      )

      request.on_complete do |r|
        @data_id = JSON.parse(r.body)["data_id"]
        @rest_ip = _build_rest_ip(JSON.parse(r.body)["rest_ip"])
      end
      request
    end

    # Returns true if the Metascan virus scan found no threats.
    # If POLL is true (false by default) then retrieve_results first.
    def clean?(poll: false)
      if self.results(poll: poll)["scan_results"]["progress_percentage"] < 100 then
        nil
      else
        self.results(poll: poll)["scan_results"]["scan_all_result_i"] == 0
      end
    end

    # Only useful for testing.
    def results=(results)
      @results = results
    end

    # Return the results of my scan.
    # If the optional argument "poll" is set to true, then attempt
    # to requery Metascan for the results before returning them.
    def results(poll: false)
      if poll and
        (!@results or @results["scan_results"]["progress_percentage"] < 100) then
        retrieve_results.run
      end
      @results
    end

    # Returns a HTTP request to retrieve the latest scan results for me.
    # Fails if called before @data_id is set (when self.run is called, or
    # my Batch runs me)
    def retrieve_results
      raise ScanDataIdMissing, "Scan " if self.data_id.nil?
      request = Typhoeus::Request.new(
        @rest_ip + '/' + @data_id,
        headers: {
          'apikey' => @client.api_key
        },
        method: :get
      )

      request.on_complete do |r|
        @results = JSON.parse(r.body)
      end

      request
    end

    private

    # Parse URI correctly regardless of port
    # inputs "rest_ip": "scan53.metascan-online.com:443/v2"
    # "rest_ip": "scan.metascan-online.com"
    def _build_rest_ip(rest_ip)
       uri = URI.parse(rest_ip)
       api_path = '/v2/file'
       return "#{uri.scheme}://#{uri.host}#{api_path}"
    end
  end
end
