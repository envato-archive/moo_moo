require 'spec_helper'
require 'date'

describe MooMoo::Provisioning do
  it { should have_registered_service(:cancel_order, :trust_service) }
  it { should have_registered_service(:cancel_pending_orders, :order) }
  it { should have_registered_service(:modify, :domain) }
  it { should have_registered_service(:process_pending, :domain) }
  it { should have_registered_service(:renew_domain, :domain, :renew) }
  it { should have_registered_service(:revoke, :domain) }
  it { should have_registered_service(:update_contacts, :domain) }
  it { should have_registered_service(:register_domain, :domain, :sw_register) }
  it { should have_registered_service(:register_trust_service, :trust_service) }
end