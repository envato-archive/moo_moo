require 'spec_helper'

describe MooMoo::Nameserver do
  it { should have_registered_service(:create, :nameserver) }
  it { should have_registered_service(:delete, :nameserver) }
  it { should have_registered_service(:get, :nameserver) }
  it { should have_registered_service(:modify, :nameserver) }
  it { should have_registered_service(:registry_check_nameserver, :nameserver) }
  it { should have_registered_service(:advanced_update_nameservers, :domain) }
end
