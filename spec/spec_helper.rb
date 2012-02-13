require 'rspec'
require 'moo_moo'
require 'webmock/rspec'
require 'vcr'
require 'extlib'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :webmock

  c.default_cassette_options = {:record => :new_episodes, :match_requests_on => [:uri]}
end

def requires_attr(attr, &block)
  expect { block.call }.to raise_error(MooMoo::ArgumentError, /Missing required parameter: #{attr}/i)
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
    MooMoo.config = MooMoo::Config.new
    if live_test?
      MooMoo.configure do |config|
        config.host = ENV['OPENSRS_TEST_URL'] if ENV['OPENSRS_TEST_URL']
        config.key  = ENV['OPENSRS_TEST_KEY']  || raise(ArgumentError, "OPENSRS_TEST_KEY is required")
        config.user = ENV['OPENSRS_TEST_USER'] || raise(ArgumentError, "OPENSRS_TEST_USER is required")
        config.pass = ENV['OPENSRS_TEST_PASS'] || raise(ArgumentError, "OPENSRS_TEST_PASS is required")
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

RSpec::Matchers.define :have_registered_service do |method_name, object_name, action_name = method_name|
  match do |object|
    parameters = {:the => :params, :cookie => "thecookie"}
    object.should_receive(:run_command)
                  .with(action_name, object_name, parameters, "thecookie")
                  .and_return("theresult")


    object.send(method_name, parameters) == "theresult"
  end

  description do
    "have registered service :#{method_name} delegating to action :#{action_name} and object :#{object_name}"
  end
end