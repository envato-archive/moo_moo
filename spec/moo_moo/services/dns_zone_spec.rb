require 'spec_helper'
require 'date'

describe MooMoo::DnsZone do
  it { should have_registered_service(:create_dns_zone, :domain) }
  it { should have_registered_service(:delete_dns_zone, :domain) }
  it { should have_registered_service(:force_dns_nameservers, :domain) }
  it { should have_registered_service(:get_dns_zone, :domain) }
  it { should have_registered_service(:reset_dns_zone, :domain) }
  it { should have_registered_service(:set_dns_zone, :domain) }
end