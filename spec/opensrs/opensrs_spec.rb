require 'spec_helper'
require 'moomoo/opensrs'
require 'moomoo/opensrs/utils'

module MooMoo
  describe OpenSRS do
    include Utils

    describe "Utils" do
      it "should raise an OpenSRSException" do
        expect {try_opensrs { raise "Exception message" } }.to raise_error OpenSRSException
      end
    end
  end
end
