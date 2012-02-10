require 'spec_helper'

describe MooMoo::Transfer do
  before(:each) do
    @opensrs = MooMoo::Transfer.new
    @registered_domain = "domainthatsnottaken1302209138.com"
    @contacts = test_contacts
  end

  describe "#cancel_transfer" do
    it "cancels the transfer for a domain" do
      VCR.use_cassette("transfer/cancel_transfer") do
        res = @opensrs.cancel_transfer(:domain => 'exampledomain.com', :reseller => MooMoo.config.user)
        res.success?.should be_false
        res.error_code.should == 400
        res.error_msg.should match(/transfer state prohibits cancellation/i)
      end
    end

    it "cancels the transfer for an order" do
      VCR.use_cassette("transfer/cancel_trasnfer_order") do
        res = @opensrs.cancel_transfer_for_order(:order_id => 1884820, :reseller => MooMoo.config.user)
        res.success?.should be_false
        res.error_code.should == 400
        res.error_msg.should match(/transfer state prohibits cancellation/i)
      end
    end
  end

  describe "#check_transfer" do
    it "shows in progress if the transfer is in progress" do
      VCR.use_cassette("transfer/check_transfer") do
        res = @opensrs.check_transfer(:domain => 'exampledomain.com')
        res.result['transferrable'].to_i.should == 0
        res.result['reason'].should match(/Transfer in progress/i)
      end
    end

    it "says the domain already exists if it does" do
      VCR.use_cassette("transfer/check_transfer_exists") do
        res = @opensrs.check_transfer(:domain => @registered_domain)
        res.result['transferrable'].to_i.should == 0
        res.result['reason'].should match(/Domain already exists in.*account/i)
      end
    end
  end

  describe "#get_transfers_away" do
    use_vcr_cassette "transfer/get_transfers_away"

    it "lists domains that have been transferred away" do
      res = @opensrs.get_transfers_away
      res.result['total'].to_i.should == 0
    end
  end

  describe "#get_tranfers_in" do
    use_vcr_cassette "transfer/get_transfers_in"

    it "lists domains that have been transferred in" do
      res = @opensrs.get_transfers_in
      res.result['total'].to_i.should == 1
      res.result['transfers']['0']['domain'].should == "testingdomain.com"
    end
  end

  describe "#process_transfer" do
    it "performs a new order with cancelled order's data" do
      VCR.use_cassette("transfer/process_transfer") do
        result = @opensrs.process_transfer(:order_id => 123, :reseller => MooMoo.config.user)
        result.success?.should be_true
      end
    end

    it "does not transfer if the status does not allow it" do
      VCR.use_cassette("transfer/process_transfer_unsuccessful") do
        result = @opensrs.process_transfer(:order_id => 123, :reseller => MooMoo.config.user)
        result.success?.should be_false
        result.error_code.should == 400
      end
    end
  end

  describe "#send_password (transfer)" do
    use_vcr_cassette "transfer/send_password"

    it "resends email message to admin contact" do
      result = @opensrs.send_password(:domain_name => 'fdsafsfsafafsaexample.com')
    end
  end

  describe "#push_transfer" do
    use_vcr_cassette "transfer/rsp2rsp_push_transfer"

    it "transfers the domain" do
      res = @opensrs.push_transfer(
        :domain   => @registered_domain,
        :username => MooMoo.config.user,
        :password => MooMoo.config.pass,
        :reseller => 'opensrs'
      )
      res.success?.should be_false
      res.error_code.should == 465
      res.error_msg.should match(/transfer permission denied/i)
    end
  end
end