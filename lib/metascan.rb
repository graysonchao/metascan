module Metascan

  require 'typhoeus'
  require 'json'

  # Paths to use for api calls.
  PATHS = {
    :scan_file            => "https://scan.metascan-online.com/v2/file",
    :results_by_data_id   => "https://scan.metascan-online.com/v2/file",
    :results_by_file_hash => "https://hashlookup.metascan-online.com/v2/hash"
  }

  # a miserable pile of library classes!
  require_relative 'scan'
  require_relative 'client'
  require_relative 'batch'

end
