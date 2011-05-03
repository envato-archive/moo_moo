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
      describe "create_nameserver" do
        use_vcr_cassette "nameserver/create"

        it "should create the nameserver" do
          res = @opensrs.create_nameserver("ns1.#{@registered_domain}", '212.112.123.11', @registered_domain)
          res.success?.should be_true
        end
      end

      describe "delete_nameserver" do
        use_vcr_cassette "nameserver/delete"

        it "should delete the nameserver" do
          res = @opensrs.delete_nameserver("ns1.#{@registered_domain}", '212.112.123.11', @registered_domain)
          res.success?.should be_true
        end
      end

      describe "get_nameserver" do
        use_vcr_cassette "nameserver/get"

        it "should return the nameservers" do
          res = @opensrs.get_nameserver(@registered_domain)
          result = res.result['nameserver_list']
          result.should have(2).nameservers
          result['0']['name'].should == "ns1.#{@registered_domain}"
          result['1']['ipaddress'].should == "212.112.123.12"
        end
      end

      describe "modify_nameserver" do
        use_vcr_cassette "nameserver/modify"

        it "should update the name of the nameserver" do
          res = @opensrs.modify_nameserver("ns22.#{@registered_domain}", '212.112.123.11', "ns3.#{@registered_domain}", @registered_domain)
          res.success?.should be_true
        end
      end
    end

  end
end
