metascan
===

A gem for accessing the Metascan Public API.

Read more at https://www.metascan-online.com/en/public-api

Usage
---
`
 require 'metascan'
 scanner = Metascan::Client.new(MY_API_KEY) 
 filename = "/etc/unwise-backups/passwd.rar" # FULLY QUALIFIED
 results = scanner.scan_file(filename, "the eagle has left the nest")
 results.clean?
 => true
`

`results` is a straight JSON.parse of the scan results given by Metascan.
For more information on the structure of this object, see the above link.
