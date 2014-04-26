Gem::Specification.new do |s|
  s.name        = 'metascan'
  s.version     = '0.1.0'
  s.date        = '2014-04-25'
  s.summary     = "Scan files for viruses using the Metascan public API."
  s.description = "Allows virus scanning files using the Metascan public API. https://www.metascan-online.com/en/public-api"
  s.authors     = ["Grayson Chao"]
  s.email       = 'graysonchao@berkeley.edu'
  s.files       = [
    "metascan.rb",
    "lib/client.rb",
    "lib/batch.rb",
    "lib/scan.rb"
  ]
  s.homepage    =
    'http://rubygems.org/gems/metascan'
  s.license       = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_runtime_dependency 'typhoeus',
    [">= 0.6.8"]
end
