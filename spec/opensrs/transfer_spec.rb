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

        it "should show in progress if the transfer is in progress" do
          result = @opensrs.check_transfer('exampledomain.com')
          result['transferrable'].to_i.should == 0
          result['reason'].should match(/Transfer in progress/i)
        end

        it "should say the domain already exists if it does" do
          result = @opensrs.check_transfer(@registered_domain)
          result['transferrable'].to_i.should == 0
          result['reason'].should match(/Domain already exists in.*account/i)
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

      describe "send_password (transfer)", :wip => true do
        use_vcr_cassette "transfer/send_password"

        it "should resend email message to admin contact" do
          result = @opensrs.send_password(@registered_domain)
        end
      end

      describe "push_transfer", :rerun => true do
        use_vcr_cassette "transfer/rsp2rsp_push_transfer"

        it "should transfer the domain" do
          res = @opensrs.push_transfer('exampledomain.com', @opensrs_user, @opensrs_pass)
          res.success?.should be_true
        end
      end
    end
  end
end
