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

    describe "Transfer Commands" do
      describe "cancel_transfer" do
        use_vcr_cassette "transfer/cancel_transfer"

        it "should cancel the transfer for a domain" do
          pending "need transfered domain"
          result = @opensrs.cancel_transfer(@registered_domain, @opensrs_user)
        end

        it "should cancel the transfer for an order" do
          pending "need order id"
          result = @opensrs.cancel_transfer_for_order(1, @opensrs_user)
        end
      end

      describe "check_transfer" do
        use_vcr_cassette "transfer/check_transfer"

        it "should do something" do
          result = @opensrs.check_transfer(@registered_domain)
          pending "need a transferred domain to check"
        end
      end

      describe "get_transfers_away" do
        use_vcr_cassette "transfer/get_transfers_away"

        it "should list domains that have been transferred away" do
          result = @opensrs.get_transfers_away
          result['total'].to_i.should == 0
        end
      end

      describe "get_tranfers_in" do
        use_vcr_cassette "transfer/get_transfers_in"

        it "should list domains that have been transferred in" do
          result = @opensrs.get_transfers_in
          result['total'].to_i.should == 0
        end
      end

      describe "process_transfer" do
        use_vcr_cassette "transfer/process_transfer"

        it "should do a new order with cancelled order's data" do
          pending "not sure"
          result = @opensrs.process_transfer(1, @opensrs_user)
        end
      end

      describe "send_password (transfer)" do
        use_vcr_cassette "transfer/send_password"

        it "should resend email message to admin contact" do
          result = @opensrs.send_password(@registered_domain)
          result.should be_true
        end
      end
    end
  end
end
