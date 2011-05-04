require 'rspec'
require 'moomoo'
require 'vcr'
require 'extlib'

def format_request(i)
  unless i.request.body.nil?
    if i.request.body.is_a?(Hash)
#          hash = i.request.body
#          i.request.body = hash.to_xml_attributes
    else
      hash = Hash.from_xml(i.request.body)
      i.request.body = hash
      unless i.request.nil?
      end
    end
  else
  end
end

VCR.config do |c|
    c.cassette_library_dir = 'spec/vcr_cassettes'
    c.stub_with :webmock
    c.before_record do |i|
      format_request i
    end
    c.before_playback do |i|
      format_request i
    end
    c.default_cassette_options = {:record => :new_episodes, :match_requests_on => [:body]}
end

def live_test?
  !ENV['OPENSRS_REAL'].nil?
end

Rspec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.before(:each) do 
    if live_test?
      @opensrs_host = ENV['OPENSRS_TEST_URL']
      @opensrs_key = ENV['OPENSRS_TEST_KEY']
      @opensrs_user = ENV['OPENSRS_TEST_USER']
      @opensrs_pass = ENV['OPENSRS_TEST_PASS']
    else
      @opensrs_host = 'test.server.com'
      @opensrs_key = '123key'
      @opensrs_user = 'opensrs_user'
      @opensrs_pass = 'password'
    end
  end
end
