require 'spec_helper'

describe MooMoo::Authentication do
  it { should have_registered_service(:change, :ownership) }
  it { should have_registered_service(:change_password, :password) }
  it { should have_registered_service(:send_authcode, :domain) }
  it { should have_registered_service(:send_password, :domain) }
end