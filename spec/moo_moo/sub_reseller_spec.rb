require 'spec_helper'

describe MooMoo::SubReseller do
  it { should have_registered_service(:create, :subreseller) }
  it { should have_registered_service(:modify, :subreseller) }
  it { should have_registered_service(:get, :subreseller) }
  it { should have_registered_service(:pay, :subreseller) }
end