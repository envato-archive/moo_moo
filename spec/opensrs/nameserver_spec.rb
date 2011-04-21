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

    describe "Nameserver Commands" do
      describe "create_nameserver", :wip => true do
        use_vcr_cassette "nameserver/create"

        it "should create the nameserver" do
          result = @opensrs.create_nameserver('ns1.example.com', '212.112.123.11')
          p result.inspect
          result.should be_true
        end
      end

      describe "delete_nameserver", :wip => true do
        use_vcr_cassette "nameserver/delete"

        it "should delete the nameserver" do
          result = @opensrs.delete_nameserver('ns1.example.com', '212.112.123.11')
          p result.inspect
          result.should be_true
        end
      end

      describe "get_nameserver", :wip => true do
        use_vcr_cassette "nameserver/get"

        it "should return the nameservers" do
          result = @opensrs.get_nameserver
          p result.inspect
          pending
        end
      end

      describe "modify_nameserver", :wip => true do
        use_vcr_cassette "nameserver/modify"

        it "should update the name of the nameserver" do
          result = @opensrs.create_nameserver('ns1.example.com', '212.112.123.11')
          result = @opensrs.modify_nameserver('ns1.example.com', '212.112.123.11', 'new-ns1.example.com')
          result.should be_true
        end
      end

      describe "set_cookie", :wip => true do
        use_vcr_cassette "nameserver/set_cookie"

        it "should set the cookie" do
          result = @opensrs.set_cookie(@opensrs_user, @opensrs_pass, @registered_domain)
          result['cookie'].should == "j8zZw8L7Ay6cbQ5P:722808:10610"
        end
      end
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
