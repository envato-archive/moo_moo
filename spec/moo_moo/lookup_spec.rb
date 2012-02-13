require 'spec_helper'

describe MooMoo::Lookup do
  it { should have_registered_service(:belongs_to_rsp, :domain) }
  it { should have_registered_service(:get_balance, :balance) }
  it { should have_registered_service(:get_deleted_domains, :domain) }
  it { should have_registered_service(:get_domain, :domain, :get) }
  it { should have_registered_service(:get_domains_contacts, :domain) }
  it { should have_registered_service(:get_domains_by_expiredate, :domain) }
  it { should have_registered_service(:get_notes, :domain) }
  it { should have_registered_service(:get_order_info, :domain) }
  it { should have_registered_service(:get_orders_by_domain, :domain) }
  it { should have_registered_service(:get_price, :domain) }
  it { should have_registered_service(:get_product_info, :trust_service) }
  it { should have_registered_service(:lookup_domain, :domain, :lookup) }
  it { should have_registered_service(:name_suggest, :domain) }
end