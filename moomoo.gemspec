# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'moomoo/version'

Gem::Specification.new do |s|
  s.name        = "MooMoo"
  s.version     = MooMoo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Parkin"]
  s.email       = ["tparkin@site5.com"]
  s.homepage    = ""
  s.summary     = %q{Implements OpenSRS XML API}
  s.description = %q{Implements OpenSRS XML API}

  s.rubyforge_project = "opensrs"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'rcov'
  s.add_development_dependency 'metric_fu'

  s.add_dependency 'extlib'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
