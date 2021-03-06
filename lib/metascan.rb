module Metascan

  require 'typhoeus'
  require 'json'

  # Paths to use for api calls.
  PATHS = {
    :scan_file            => "https://scan.metascan-online.com/v2/file",
    :results_by_data_id   => "https://scan.metascan-online.com/v2/file",
    :results_by_file_hash => "https://hashlookup.metascan-online.com/v2/hash",
    :scan_ip              => "https://ipscan.metascan-online.com/v1/scan"
  }

  # a miserable pile of library classes!
  require_relative 'metascan/scan'
  require_relative 'metascan/client'
  require_relative 'metascan/batch'

  class ScanDataIdMissing < StandardError; end

end
