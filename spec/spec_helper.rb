require 'rspec'
require 'moomoo'

Rspec.configure do |c|
  c.before(:each) do 
    @opensrs_host = ENV['OPENSRS_TEST_URL']
    @opensrs_key = ENV['OPENSRS_TEST_KEY']
    @opensrs_user = ENV['OPENSRS_TEST_USER']
    @opensrs_pass = ENV['OPENSRS_TEST_PASS']
  end
end
