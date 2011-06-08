# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'moo_moo/version'

Gem::Specification.new do |s|
  s.name        = "Moo_Moo"
  s.version     = MooMoo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Parkin"]
  s.email       = ["tparkin@site5.com"]
  s.homepage    = ""
  s.summary     = %q{Implements OpenSRS XML API}
  s.description = %q{Implements OpenSRS XML API}

  s.rubyforge_project = "opensrs"

  s.add_runtime_dependency('jruby-openssl', '~> 0.7.3') if RUBY_PLATFORM == 'java'
  s.add_development_dependency 'rake', '~> 0.8.7'
  s.add_development_dependency 'rspec', '~> 2.5.0'
  s.add_development_dependency 'fakeweb', '~> 1.3.0'
  s.add_development_dependency 'vcr', '~> 1.9.0'
  if !defined?(RUBY_ENGINE) || RUBY_ENGINE != 'rbx'
    s.add_development_dependency 'rcov', '>= 0.9.9'
    s.add_development_dependency 'metric_fu', '>= 2.1.1'
  end

  s.add_dependency 'extlib'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
