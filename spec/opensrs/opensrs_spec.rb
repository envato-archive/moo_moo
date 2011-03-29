require 'spec_helper'
require 'moomoo/opensrs'

module MooMoo

  def random_domain
    "domainthatsnottaken#{Time.now.to_i}.com"
  end

  describe OpenSRS do
    before(:each) do
      @opensrs = OpenSRS.new(@opensrs_host, @opensrs_key, @opensrs_user, @opensrs_password)
    end

    describe "OpenSRS" do
      it "should use the default port" do
        @opensrs.port.should == 55443
      end
    end

    describe "can register?", :wip => true do
      it "should return true for a valid, available domain" do
        result = @opensrs.can_register?('opensrsgemtestingdomain.com')
        result.should be_true
      end

      it "should raise an exception for an invalid domain" do
        expect { @opensrs.can_register?('example') }.to raise_error(OpenSRSException, /701/i)
      end

      it "should return false for an unavailable domain" do
        result = @opensrs.can_register?('example.com')
        result.should be_false
      end
    end

    describe "can register list?" do
      it "should work" do
        result = @opensrs.can_register_list?('example.com', random_domain, random_domain)
p result.inspect
      end
    end

    describe "register" do
      it "should register a domain that is available" do
        result = @opensrs.register(random_domain)
        result["is_success"].to_i.should == 1 
        result["response_code"].to_i.should == 200 
      end

      it "should not register a domain that is not available" do
        result = @opensrs.register('example.com')
        result["is_success"].to_i.should == 0 
        result["response_code"].to_i.should == 485 
      end
    end
  end
end
