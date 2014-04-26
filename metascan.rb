module Metascan

  require 'typhoeus'
  require 'json'

  # Paths to use for api calls.
  PATHS = {
    :scan_file            => "https://api.metascan-online.com/v1/file",
    :results_by_data_id   => "https://api.metascan-online.com/v1/file/",
    :results_by_file_hash => "https://api.metascan-online.com/v1/hash/"
  }

  # a miserable pile of library classes!
  require_relative 'lib/scan'
  require_relative 'lib/client'
  require_relative 'lib/batch'

end
