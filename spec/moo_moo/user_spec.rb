require 'spec_helper'

describe MooMoo::User do
  it { should have_registered_service(:add, :subuser) }
  it { should have_registered_service(:delete, :subuser) }
  it { should have_registered_service(:get, :subuser) }
  it { should have_registered_service(:modify, :subuser) }
  it { should have_registered_service(:get_info, :userinfo, :get) }
end