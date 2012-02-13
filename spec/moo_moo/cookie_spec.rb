require 'spec_helper'

describe MooMoo::Cookie do
  it { should have_registered_service(:set, :cookie) }
  it { should have_registered_service(:delete, :cookie) }
  it { should have_registered_service(:update, :cookie) }
  it { should have_registered_service(:quit_session, :session, :quit) }
end