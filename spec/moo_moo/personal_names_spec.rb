require 'spec_helper'

describe MooMoo::PersonalNames do
  it { should have_registered_service(:register, :surname, :su_register) }
  it { should have_registered_service(:query, :surname) }
  it { should have_registered_service(:update, :surname) }
  it { should have_registered_service(:delete, :surname) }
end