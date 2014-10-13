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
  s.summary     = %q{Implements OpenSRS XML Domain API}
  s.description = %q{Implements OpenSRS XML Domain API}
  s.license     = 'MIT'

  s.rubyforge_project = "opensrs"

  s.add_runtime_dependency 'faraday', '~> 0.9.0'
  s.add_runtime_dependency 'jruby-openssl', '>= 0.7.3' if RUBY_PLATFORM == 'java'

  s.add_development_dependency 'rake', '~> 0.9.2.2'
  s.add_development_dependency 'rspec', '~> 2.10.0'
  s.add_development_dependency 'rdoc', '~> 3.12'
  s.add_development_dependency 'webmock', '~> 1.8.7'
  s.add_development_dependency 'vcr', '~> 1.11.3'

  s.files       += %w[Gemfile LICENSE Rakefile README.md]
  s.files       += Dir['{config,lib,spec}/**/*']
  s.test_files   = Dir['spec/**/*']
end
