# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'moo_moo/version'

Gem::Specification.new do |s|
  s.name        = "moo_moo"
  s.version     = MooMoo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Parkin"]
  s.email       = ["tparkin@site5.com"]
  s.homepage    = ""
  s.summary     = %q{Implements OpenSRS XML API}
  s.description = %q{Implements OpenSRS XML API}

  s.rubyforge_project = "opensrs"

  s.add_runtime_dependency 'extlib', '~> 0.9.15'
  s.add_runtime_dependency 'faraday', '~> 0.8.0.rc2'
  s.add_runtime_dependency 'jruby-openssl', '~> 0.7.3' if RUBY_PLATFORM == 'java'
  
  s.add_development_dependency 'rake', '~> 0.9.2.2'
  s.add_development_dependency 'rspec', '~> 2.8.0'
  s.add_development_dependency 'rdoc', '~> 3.12'
  s.add_development_dependency 'webmock', '~> 1.7.10'
  s.add_development_dependency 'vcr', '~> 1.11.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
