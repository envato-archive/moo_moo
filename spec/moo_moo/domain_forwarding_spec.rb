require 'spec_helper'

describe MooMoo::DomainForwarding do
  it { should have_registered_service(:create, :domain, :create_domain_forwarding) }
  it { should have_registered_service(:delete, :domain, :delete_domain_forwarding) }
  it { should have_registered_service(:get, :domain, :get_domain_forwarding) }
  it { should have_registered_service(:set, :domain, :set_domain_forwarding) }
end