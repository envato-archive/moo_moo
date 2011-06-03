require 'rspec'
require 'moo_moo'
require 'vcr'
require 'extlib'


module MooMoo
  autoload :Config, 'moo_moo/config'

  class << self
    attr_accessor :config
  end

  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end
MooMoo.configure do |config|
  config.host = ENV['OPENSRS_TEST_URL']
  config.key = ENV['OPENSRS_TEST_KEY']
  config.user = ENV['OPENSRS_TEST_USER']
  config.pass = ENV['OPENSRS_TEST_PASS']
end

def requires_attr(attr, &block)
  expect { block.call }.to raise_error(MooMoo::MooMooArgumentError, /Missing required parameter: #{attr}/i)
end

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb

  c.default_cassette_options = {:record => :new_episodes, :match_requests_on => [:uri]}
end

def live_test?
  !ENV['OPENSRS_REAL'].nil?
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.before(:each) do
    if live_test?
      MooMoo.configure do |config|
        config.host = ENV['OPENSRS_TEST_URL']
        config.key = ENV['OPENSRS_TEST_KEY']
        config.user = ENV['OPENSRS_TEST_USER']
        config.pass = ENV['OPENSRS_TEST_PASS']
      end
    else
      MooMoo.configure do |config|
        config.host = 'server.com'
        config.key = '123key'
        config.user = 'opensrs_user'
        config.pass = 'password'
      end
    end

#    @opensrs = OpenSRS.new(MooMoo.config.host, MooMoo.config.key, MooMoo.config.user, MooMoo.config.pass)
  end
end
