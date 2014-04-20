metascan
===

A gem for accessing the Metascan Public API.

Read more at https://www.metascan-online.com/en/public-api

Usage
---
    require 'metascan'
    scanner = Metascan::Client.new(MY_API_KEY) 
    filename = "/etc/unwise-backups/passwd.rar" # FULLY QUALIFIED
    results = scanner.scan_file(filename, archivepwd: "the eagle has left the nest")
    => <Metascan::Scan ... >
    results.clean?
    => true

`results` has all the fields of a straight `JSON.parse` of the response body in the scan results given by Metascan.

It also exposes a few handy methods.

+ `Metascan::Scan#clean?` 
returns true iff the scan came back with no threat detected, or the file was empty.
+ `Metascan::Scan#retrieve_results` 
makes an API call and updates self.results with the latest scan progress.
+ `Metascan::Scan#results(poll: true)` 
returns last fetched results; if `poll == true`, `retrieve_results` is called first.

For more information on the structure of the Metascan response object, see the above link under "Retrieving scan reports using data hash."
