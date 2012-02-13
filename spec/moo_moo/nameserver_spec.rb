require 'spec_helper'

describe MooMoo::Nameserver do
  it { should have_registered_service(:create, :nameserver) }
  it { should have_registered_service(:delete, :nameserver) }
  it { should have_registered_service(:get, :nameserver) }
  it { should have_registered_service(:modify, :nameserver) }
  it { should have_registered_service(:advanced_update, :domain, :advanced_update_nameservers) }
  it { should have_registered_service(:registry_add, :nameserver, :registry_add_ns) }
  it { should have_registered_service(:registry_check, :nameserver, :registry_check_nameserver) }
end