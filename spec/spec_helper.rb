require 'rspec'
require 'moo_moo'
require 'vcr'
require 'extlib'

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
  end
end

RSpec::Matchers.define :have_attr_accessor do |attribute|
  match do |object|
    object.respond_to?(attribute) && object.respond_to?("#{attribute}=")
  end

  description do
    "have attr_writer :#{attribute}"
  end
end
