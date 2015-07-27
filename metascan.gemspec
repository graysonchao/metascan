$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
gemname = "metascan"
require "#{gemname}/version"

Gem::Specification.new do |s|
  s.name        = gemname
  s.version     = Metascan::VERSION
  s.date        = '2014-04-25'
  s.summary     = "Scan files for viruses using the Metascan public API."
  s.description = "Allows virus scanning files using the Metascan public API. https://www.metascan-online.com/en/public-api"
  s.authors     = ["Grayson Chao"]
  s.email       = 'graysonchao@berkeley.edu'
  s.files       = `git ls-files`.split($\)
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})
  s.homepage    = 'https://rubygems.org/gems/metascan'
  s.license     = 'MIT'
  s.add_development_dependency('bump', '~> 0.3')
  s.add_development_dependency('rspec', '~> 3.3')
  s.add_development_dependency('webmock', '~> 1.21')
  s.add_runtime_dependency('typhoeus', "~> 0.6.8")
end
