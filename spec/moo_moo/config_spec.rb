require 'spec_helper'

describe MooMoo::Config do
  before :each do
    @config = MooMoo::Config.new
  end

  it { @config.should have_attr_accessor :host }
  it { @config.should have_attr_accessor :key  }
  it { @config.should have_attr_accessor :user }
  it { @config.should have_attr_accessor :pass }
end
