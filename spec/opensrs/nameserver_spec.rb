require 'spec_helper'
require 'moo_moo/opensrs'

module MooMoo

  describe OpenSRS do
    before(:each) do
      def random_domain
        "domainthatsnottaken#{Time.now.to_i}.com"
      end

      @opensrs = OpenSRS.new(@opensrs_host, @opensrs_key, @opensrs_user, @opensrs_pass)
      @registered_domain = "domainthatsnottaken1302209138.com"
    end

    describe "NameserverCommands" do
      describe "#create_nameserver" do
        use_vcr_cassette "nameserver/create"

        it "creates the nameserver" do
          res = @opensrs.create_nameserver(
            :name => "ns1.#{@registered_domain}", 
            :ip => '212.112.123.11', 
            :domain => @registered_domain)
          res.success?.should be_true
        end
      end

      describe "#delete_nameserver" do
        use_vcr_cassette "nameserver/delete"

        it "deletes the nameserver" do
          res = @opensrs.delete_nameserver(
            :name => "ns1.#{@registered_domain}", 
            :ip => '212.112.123.11', 
            :domain => @registered_domain)
          res.success?.should be_true
        end
      end

      describe "#get_nameserver" do
        use_vcr_cassette "nameserver/get"

        it "returns the nameservers" do
          res = @opensrs.get_nameserver(@registered_domain)
          result = res.result['nameserver_list']
          result.should have(2).nameservers
          result['0']['name'].should == "ns1.#{@registered_domain}"
          result['1']['ipaddress'].should == "212.112.123.12"
        end
      end

      describe "#modify_nameserver" do
        use_vcr_cassette "nameserver/modify"

        it "updates the name of the nameserver" do
          res = @opensrs.modify_nameserver(
            :name => "ns22.#{@registered_domain}", 
            :ip => '212.112.123.11', 
            :new_name => "ns3.#{@registered_domain}", 
            :domain => @registered_domain)
          res.success?.should be_true
        end
      end
    end

  end
end
