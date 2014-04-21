module Metascan

  require 'typhoeus'

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

    # Scan a batch of files by processing the requests in parallel with
    # Typhoeus::Hydra. Returns a Metascan::Batch object, which can iterate
    # over the set of finished scans.
    # Sample usage:
    #
    #   scanner = Metascan::Client.new(MY_API_KEY)
    #   filenames = ["/etc/passwd", "/dev/sda0", "/dev/random.tgz"] # don't try this
    #   scanner.scan_files(filenames, archivepwds: { "/dev/random.tgz" => "hunter2" })
    #   => <Metascan::Batch ...>
    def scan_batch(filenames, archivepwds: nil)
      scans = Metascan::Batch.new(self.hydra)
      filenames.each do |f|
        scan = Metascan::QueuedScan.new(f, self, scans)
        scans.add(scan)
      end
      scans.run
      scans
    end
  end
end
