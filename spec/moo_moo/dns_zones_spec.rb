require 'spec_helper'

describe MooMoo::DnsZones do
  it { should have_registered_service(:create, :domain, :create_dns_zone) }
  it { should have_registered_service(:delete, :domain, :delete_dns_zone) }
  it { should have_registered_service(:force_dns_nameservers, :domain) }
  it { should have_registered_service(:get, :domain, :get_dns_zone) }
  it { should have_registered_service(:reset, :domain, :reset_dns_zone) }
  it { should have_registered_service(:set, :domain, :set_dns_zone) }
end