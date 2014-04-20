module Metascan

  require 'typhoeus'
  require 'json'

  # Constants like paths and stuff.
  PATHS = {
    :scan_file            => "https://api.metascan-online.com/v1/file",
    :results_by_data_id   => "https://api.metascan-online.com/v1/file/",
    :results_by_file_hash => "https://api.metascan-online.com/v1/hash/"
  }

  # A single scan on the Metascan service.
  # Initialized with the parameters to scan,
  # exposes methods to inspect the scan results.
  class Scan
    def initialize(filename, client, archivepwd: nil)
      @filename   = filename
      @client     = client
      @archivepwd = archivepwd
    end

    # Initiate a scan of @filename
    def run
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
        retrieve_results
      end

      request.run
    end

    # Is my file clean?
    def clean?
      self.results["scan_results"]["scan_all_result_i"] == 0
    end

    # Only useful for testing.
    def results=(results)
      @results = results
    end

    # Return the results of my scan.
    # If the optional argument "poll" is set to true, then attempt
    # to requery Metascan for the results before returning them.
    def results(poll: true)
      if !@results or 
        (poll and @results["scan_results"]["progress_percentage"] < 100) then
        @results = retrieve_results
      end
      @results
    end

    def data_id
      @data_id
    end

    def retrieve_results
      request = Typhoeus::Request.new(
        Metascan::PATHS[:results_by_data_id] + @data_id,
        headers: {
          'apikey' => @client.api_key
        },
        method: :get
      )

      response = request.run
      JSON.parse(response.body)
    end
  end

  # The Client object, which stores an API key and has a (currently not used)
  # Typhoeus::Hydra for when you have a lot of requests to make at once.
  class Client
    # An API key is required. Free at www.metascan-online.com
    def initialize(api_key)
      @api_key = api_key
      @hydra   = Typhoeus::Hydra.hydra
    end

    def api_key
      @api_key
    end

    # A Typhoeus Hydra manages parallel HTTP requests.
    def hydra
      if !@hydra
        @hydra = Typhoeus::Hydra.hydra
      end
      @hydra
    end

    # Returns a Scan object
    # Sample usage:
    #
    #   scanner = Metascan::Client.new(MY_API_KEY) 
    #   filename = "/etc/unwise-backups/passwd.rar" # FULLY QUALIFIED
    #   scanner.scan_file(filename, archivepwd: "the eagle has left the nest")
    #   => <Metascan::Scan ... >
    #
    # https://www.metascan-online.com/en/public-api
    def scan_file(filename, archivepwd: nil)
      scan = Metascan::Scan.new(filename, self)
      scan.run
      scan
    end
  end
end
