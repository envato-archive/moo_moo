require 'spec_helper'
require 'moomoo/opensrs'
require 'date'

module MooMoo

  describe OpenSRS do
    before(:each) do
      def random_domain
        "domainthatsnottaken#{Time.now.to_i}.com"
      end

      @opensrs = OpenSRS.new(@opensrs_host, @opensrs_key, @opensrs_user, @opensrs_pass)
      @registered_domain = "domainthatsnottaken1302209138.com"
    end

    describe "Lookup Commands" do
      describe "belongs_to_rsp" do
        use_vcr_cassette "lookup/belongs_to_rsp"

        it "should return false for a domain that is not owned by the rsp" do
          res = @opensrs.belongs_to_rsp?('example.com')
          res.result['belongs_to_rsp'].to_i.should == 0
        end

        it "should return true for a domain owned by the rsp" do
          res = @opensrs.belongs_to_rsp?(@registered_domain)
          res.result['belongs_to_rsp'].to_i.should == 1
        end
      end

      describe "get_balance" do
        use_vcr_cassette "lookup/get_balance"

        it "should return the balance" do
          res = @opensrs.get_balance
          res.result['balance'].to_f.should == 7312.24
          res.result['hold_balance'].to_f.should == 0.00
        end
      end

      describe "get_deleted_domains" do
        use_vcr_cassette "lookup/get_deleted_domains"

        it "should return domains that have been deleted" do
          result = @opensrs.get_deleted_domains.result
          result['total'].to_i.should == 2
          result['del_domains']['0']['name'].should == "example.com"
          result['del_domains']['0']['delete_date_epoch'].should == "1294426313"
          result['del_domains']['0']['expiredate_epoch'].should == "1325980310"
        end
      end

      describe "get domain" do
        use_vcr_cassette "lookup/get_domain"

        it "should return all the info" do
          res = @opensrs.set_cookie(@opensrs_user, @opensrs_pass, @registered_domain)
          result = @opensrs.get_domain(@registered_domain, res.result['cookie']).result
          result['auto_renew'].to_i.should == 1
          result['contact_set']['admin']['org_name'].should == "Example Inc."
          result['nameserver_list']['0']['name'].should == "ns2.systemdns.com"
        end
      end

      describe "get_domains_contacts" do
        use_vcr_cassette "lookup/get_domains_contacts"

        it "should return the domains contacts" do
          result = @opensrs.get_domains_contacts(@registered_domain).result
          result[@registered_domain]['contact_set']['owner']['address2'].should == "Suite 500"
          result[@registered_domain]['contact_set']['billing']['org_name'].should == "Example Inc."
        end
      end

      describe "get_domains_by_expiredate" do
        use_vcr_cassette "lookup/get_domains_by_expiredate"

        it "should return domains within an expiration range" do
          result = @opensrs.get_domains_by_expiredate(Date.today, Date.today + 365).result
          result['total'].to_i.should == 2
          result['exp_domains']['0']['name'].should == "example.com"
          result['exp_domains']['0']['f_auto_renew'].should == "N"
          result['exp_domains']['0']['f_let_expire'].should == "N"
          result['exp_domains']['0']['expiredate'].should == "2011-11-03 16:14:46"
        end
      end

      describe "get_notes" do
        use_vcr_cassette "lookup/get_notes"

        it "should return the notes for a domain" do
          result = @opensrs.get_notes_for_domain(@registered_domain).result
          result['total'].to_i.should == 4
          result['notes']['1']['note'].should match(/Order.*?\d+.*?Domain Registration.*?1 year/i)
        end

        it "should return the notes for an order" do
          result = @opensrs.get_notes_for_order(@registered_domain, 1855625).result
          result['page'].to_i.should == 1
          result['notes'].should be_a_kind_of(Hash)
          result['notes'].should be_empty
        end

        it "should return the notes for a transfer" do
          pending "need a transfer id"
          result = @opensrs.get_notes_for_transfer(@registered_domain, 1)
        end
      end

      describe "get_order_info" do
        use_vcr_cassette "lookup/get_order_info"

        it "should return the order info" do
          result = @opensrs.get_order_info(1855625).result
          result['owner_address2'].should == "Suite 500"
          result['billing_org_name'].should == "Example Inc."
          result['period'].to_i.should == 1
        end
      end

      describe "get_orders_by_domain" do
        use_vcr_cassette "lookup/get_orders_by_domain"

        it "should return the orders for a domain" do
          result = @opensrs.get_orders_by_domain(@registered_domain).result
          result['orders'].should be_a_kind_of(Hash)
          result['orders'].should have(2).domain
          result['orders']['0']['id'].to_i.should == 1862773
        end
      end

      describe "get_price" do
        use_vcr_cassette "lookup/get_price"

        it "should return the price" do
          res = @opensrs.get_price('example.com')
          res.result['price'].to_f.should == 11.62
        end
      end

      describe "get_product_info", :wip => true do
        use_vcr_cassette "lookup/get_product_info"

        it "should return the product info" do
          res = @opensrs.get_product_info(99)
          raise res.inspect
        end
      end

      describe "lookup domain" do
        use_vcr_cassette "lookup/lookup_domain"

        it "should return the availbility of an available domain" do
          result = @opensrs.lookup_domain('example.com').result
          result['status'].should == "available"
        end

        it "should return the availability of a registered domain" do
          result = @opensrs.lookup_domain(@registered_domain).result
          result['status'].should == "taken"
        end
      end

      describe "name_suggest" do
        use_vcr_cassette "lookup/name_suggest"

        it "should return suggested names for a domain" do
          result = @opensrs.name_suggest("random_domain", [".com", ".net"]).result
          result['lookup']['count'].to_i.should == 4
          result['lookup']['items']['0']['domain'].should == "randomdomain.com"
          result['lookup']['items']['0']['status'].should == "taken"

          result['suggestion']['count'].to_i.should == 49
          result['suggestion']['items']['0']['domain'].should == "aimlessdomain.com"
          result['suggestion']['items']['0']['status'].should == "available"
        end
      end
    end
  end
end
