require 'spec_helper'

describe MooMoo do
  describe "::Version" do
    it "has a valid version" do
      MooMoo::Version.should match /\d+\.\d+\.\d+/
    end
  end

  describe "::configure" do
    it { MooMoo.configure.should be_a MooMoo::Config }

    it "loads default settings from config if none are provided" do
      MooMoo.configure do |config|
        config.host     = 'host.com'
        config.key      = 'secret'
        config.username = 'username'
      end

      opensrs = MooMoo::BaseCommand.new

      opensrs.host.should     == 'host.com'
      opensrs.key.should      == 'secret'
      opensrs.username.should == 'username'
    end
  end

  describe "::config" do
    it { MooMoo.should have_attr_accessor :config }
  end
end
