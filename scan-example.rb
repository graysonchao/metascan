require_relative 'metascan'

### Create a new scan object ###
scanner = Metascan::Client.new(MY_API_KEY)

### Scan a single file ###
filename = '/bin/bash'

print "Scanning file: #{filename} "
results = scanner.scan_file(filename)

status = nil
until status != nil do
  print "."
  status = results.clean?(poll: true)
  sleep 5
end
puts ' clean: ' + results.clean?.to_s


### Scan multiple files

filenamesArray = ['/bin/cat', '/bin/chmod', '/bin/less']
print "Scanning multiple files "
results = scanner.scan_batch(filenamesArray)

status = nil
until status != nil do
  print "."
  status = results.clean?
  sleep 5
end
puts ' clean: ' + results.clean?.to_s
