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

+ `Metascan::Scan#clean?(poll: false)` 
returns true iff the scan came back with no threat detected, or the file was empty. if `poll == true` then `retrieve_results` is called first.
+ `Metascan::Scan#retrieve_results` 
makes an API call and updates self.results with the latest scan progress.
+ `Metascan::Scan#results(poll: true)` 
returns last fetched results; if `poll == true`, `retrieve_results` is called first.

Batch Scanning
---
    require 'metascan'
    scanner = Metascan::Client.new(MY_API_KEY)
    filenames = ["/etc/passwd", "/dev/sda0", "/dev/random.tgz"] # don't try this
    results = scanner.scan_batch(filenames, archivepwds: { "/dev/random.tgz" => "hunter2" })
    => <Metascan::Batch ...>
    results.retrieve_results
    results.clean?
    => true #true iff all files in filenames are clean
    results.add(scanner.scan_file("/mydirtyfile.rar"))
    results.run
    results.retrieve_results
    results.clean?
    => false

+ `Metascan::Batch#add`
add a scan to the batch. call `run` to run the scan (involves uploading the file) and `retrieve_results` to check on the current progress.

+ `Metascan::Batch#clean? `
returns true iff all the scans in the batch came back clean last time `retrieve_results` was called.

+ `Metascan::Batch#dirty`
returns a list of the dirty scans in the batch.

+ `Metascan::Batch#retrieve_results`
fetch the latest progress report for each scan in the batch.

+ `Metascan::Batch#run`
run any remaining scans, uploading their files and retrieving the key to fetch results on the scan.

For more information on the structure of the Metascan response object, see the above link under "Retrieving scan reports using data hash."
