module Metascan

  require_relative 'scan'
  require_relative 'client'

  # A batch of scanned files. Exposes similar methods to Scan, but
  # for a group of files.
  class Batch

    # @scans is a hash like so:
    # {
    #   filename (string) => <Metascan::Scan>,
    #   filename (string) => <Metascan::Scan>,
    #   ...
    # }
    attr_accessor :scans

    def initialize(hydra)
      @scans = {}
      @hydra = hydra
    end

    # Add a scan to my scans, man.
    def add(scan)
      unless scan.kind_of? Metascan::Scan
        return
      end
      @scans = @scans.merge({ scan.filename => scan })
      @hydra.queue(scan.request)
    end

    # Return true iff all my scans are clean.
    def clean?
      @scans.map{ |id, s| s.clean? poll: true }.inject{ |s1, s2| s1 && s2 }
    end

    # Return a list of all the dirty scans in my batch.
    def dirty
      @scans.select{ |id, s| !s.clean? }
    end

    def run
      @hydra.run
      @scans.each do |id, s|
        @hydra.queue(s.retrieve_results)
      end
      @hydra.run
    end

  end

end
