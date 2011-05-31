require 'rspec'
require 'moo_moo'
require 'vcr'
require 'extlib'

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
      @opensrs_host = ENV['OPENSRS_TEST_URL']
      @opensrs_key = ENV['OPENSRS_TEST_KEY']
      @opensrs_user = ENV['OPENSRS_TEST_USER']
      @opensrs_pass = ENV['OPENSRS_TEST_PASS']
    else
      @opensrs_host = 'server.com'
      @opensrs_key = '123key'
      @opensrs_user = 'opensrs_user'
      @opensrs_pass = 'password'
    end
  end
end
