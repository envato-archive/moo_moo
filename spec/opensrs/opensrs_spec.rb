require 'spec_helper'
require 'moo_moo/opensrs'
require 'moo_moo/opensrs/utils'

module MooMoo
  describe OpenSRS do
    include Utils

    describe "Utils" do
      it "raises an OpenSRSException" do
        expect {try_opensrs { raise "Exception message" } }.to raise_error OpenSRSException
      end
    end

    describe "Config" do
      it "loads default settings from config if none are provided" do
        MooMoo.configure do |config|
          config.host = 'host.com'
          config.key = 'secret'
          config.user = 'username'
          config.pass = 'secret2'
        end

        opensrs = OpenSRS.new

        opensrs.host.should == 'host.com'
        opensrs.key.should == 'secret'
        opensrs.user.should == 'username'
        opensrs.pass.should == 'secret2'
      end
    end
  end
end
