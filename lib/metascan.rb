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
      @filename = filename
      @client = client

      @request = Typhoeus::Request.new(
        Metascan::PATHS[:scan_file],
        headers: {
          'filename' => filename,
          'archivepwd' => archivepwd,
          'apikey' => client.api_key
        }.select { |k, v| !v.nil? },
        method: :post,
        body: { file: File.open(filename, "r") }
      )
    end

    def run
      @response = nil
      @request.on_complete do |r|
        @data_id = JSON.parse(r.body)["data_id"]
        retrieve_results
      end
      puts @results
    end

    def clean?
    end

    def results
      nil || @results
    end

    def data_id
      nil || @data_id
    end

    private
    def retrieve_results
      # this is the only field of the responsek
      request = Typhoeus::Request.new(
        Metascan::PATHS[:results_by_data_id] + @data_id,
        headers: {
          'apikey' => @client.api_key
        },
        method: :get
      )
      response = request.run
      @results = JSON.parse(response.body)
    end

  end

  class Client

    # An API key is required. Free at www.metascan-online.com
    def initialize(api_key)
      @api_key = api_key
      @hydra = Typhoeus::Hydra.hydra
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
    #   scanner.scan_file(filename, "the eagle has left the nest")
    #   => <Metascan::Scan ... >
    #
    # https://www.metascan-online.com/en/public-apikbb
    def scan_file(filename, archivepwd: nil)
      scan = Metascan::Scan.new(filename, self)
      scan.run
      scan
    end
  end
end
