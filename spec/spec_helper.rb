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

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb

  c.default_cassette_options = {:record => :new_episodes, :match_requests_on => [:uri]}
end

def requires_attr(attr, &block)
  expect { block.call }.to raise_error(MooMoo::MooMooArgumentError, /Missing required parameter: #{attr}/i)
end

def live_test?
  !ENV['OPENSRS_REAL'].nil?
end

def random_domain
  "domainthatsnottaken#{Time.now.to_i}.com"
end

def test_contacts
  contact = {
    :first_name  => "Owen",
    :last_name   => "Ottway",
    :phone       => "+1.4165550123x1902",
    :fax         => "+1.4165550124",
    :email       => "ottway@example.com",
    :org_name    => "Example Inc.",
    :address1    => "32 Oak Street",
    :address2    => "Suite 500",
    :address3    => "Owner",
    :city        => "SomeCity",
    :state       => "CA",
    :country     => "US",
    :postal_code => "90210",
    :url         => "http://www.example.com"
  }

  out = {
    :title   => "blahblah",
    :owner   => contact,
    :admin   => contact,
    :billing => contact,
    :tech    => contact
  }
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
    "have attr_accessor :#{attribute}"
  end
end
