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
  end
end
