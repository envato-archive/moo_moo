require 'spec_helper'
require 'moomoo/opensrs'

module MooMoo

  describe OpenSRS do
    before(:each) do
      def random_domain
        "domainthatsnottaken#{Time.now.to_i}.com"
      end

      @opensrs = OpenSRS.new(@opensrs_host, @opensrs_key, @opensrs_user, @opensrs_pass)
      @registered_domain = "domainthatsnottaken1302209138.com"
    end

=begin
    describe "Nameserver Commands" do
      describe "cancel_transfer" do
        it "should cancel the transfer for a domain" do
          pending "need transfered domain"
          result = @opensrs.cancel_transfer(@registered_domain, @opensrs_user)
        end

        it "should cancel the transfer for an order" do
          pending "need order id"
          result = @opensrs.cancel_transfer_for_order(1, @opensrs_user)
        end
      end
    end
=end
  end
end
