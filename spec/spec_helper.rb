require 'rspec'
require 'moomoo'
require 'vcr'
require 'extlib'

VCR.config do |c|
    c.cassette_library_dir = 'spec/vcr_cassettes'
    c.stub_with :webmock
    c.before_playback do |i|
      unless i.request.body.nil?
        if i.request.body.is_a?(Hash)
#          hash = i.request.body
#          i.request.body = hash.to_xml_attributes
        else
          hash = Hash.from_xml(i.request.body)
          i.request.body = hash
        end
      end
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
      @opensrs_host = 'example.com'
      @opensrs_key = '123key'
      @opensrs_user = 'opensrs_user'
      @opensrs_pass = 'password'
    end
  end
end
