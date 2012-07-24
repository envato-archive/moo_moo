require 'spec_helper'

describe MooMoo::Transfer do
  it { should have_registered_service(:cancel_transfer, :transfer) }
  it { should have_registered_service(:cancel_transfer_for_order, :transfer) }
  it { should have_registered_service(:check_transfer, :domain) }
  it { should have_registered_service(:get_transfers_away, :domain) }
  it { should have_registered_service(:get_transfers_in, :domain) }
  it { should have_registered_service(:process_transfer, :transfer) }
  it { should have_registered_service(:send_password, :transfer) }
  it { should have_registered_service(:push_transfer, :domain, :rsp2rsp_push_transfer) }
end