require 'spec_helper'
require 'moo_moo/opensrs'

module MooMoo

  describe OpenSRS do
    before(:each) do
      def random_domain
        "domainthatsnottaken#{Time.now.to_i}.com"
      end

      @opensrs = OpenSRS.new(MooMoo.config.host, MooMoo.config.key, MooMoo.config.user, MooMoo.config.pass)
      @registered_domain = "domainthatsnottaken1302209138.com"
    end

    describe "NameserverCommands" do
      describe "#create_nameserver" do
        use_vcr_cassette "nameserver/create"

        it "requires a name", :wip => true do
          requires_attr(:name) { @opensrs.create_nameserver(:ip => '123.123.123.123', :domain => 'example.com') }
        end

        it "requires a ip", :wip => true do
          requires_attr(:ip) { @opensrs.create_nameserver(:name => 'blah', :domain => 'example.com') }
        end

        it "requires a domain", :wip => true do
          requires_attr(:domain) { @opensrs.create_nameserver(:name => 'blah', :ip => '123.123.123.123') }
        end

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

        it "requires a name", :wip => true do
          requires_attr(:name) { @opensrs.delete_nameserver(:ip => '123.123.123.123', :domain => 'example.com') }
        end

        it "requires a ip", :wip => true do
          requires_attr(:ip) { @opensrs.delete_nameserver(:name => 'blah', :domain => 'example.com') }
        end

        it "requires a domain", :wip => true do
          requires_attr(:domain) { @opensrs.delete_nameserver(:name => 'blah', :ip => '123.123.123.123') }
        end

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

        it "requires a name", :wip => true do
          requires_attr(:name) { @opensrs.modify_nameserver(
            :ip => '123.123.123.123',
            :new_name => 'blah',
            :domain => 'example.com') 
          }
        end

        it "requires a ip", :wip => true do
          requires_attr(:ip) { @opensrs.modify_nameserver(
            :name => 'blah',
            :new_name => 'blah',
            :domain => 'example.com') 
          }
        end

        it "requires a domain", :wip => true do
          requires_attr(:domain) { @opensrs.modify_nameserver(
            :name => 'blah',
            :ip => '123.123.123.123',
            :new_name => 'blah')
          }
        end

        it "requires a new_name", :wip => true do
          requires_attr(:new_name) { @opensrs.modify_nameserver(
            :name => 'blah',
            :ip => '123.123.123.123',
            :domain => 'example.com') 
          }
        end

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
