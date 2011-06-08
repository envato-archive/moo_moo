require 'spec_helper'
require 'moo_moo/opensrs'
require 'date'

module MooMoo

  describe OpenSRS do
    before(:each) do
      def random_domain
        "domainthatsnottaken#{Time.now.to_i}.com"
      end

      @opensrs = OpenSRS::Base.new
      @registered_domain = "domainthatsnottaken1302209138.com"
    end

    describe "LookupCommands" do
      describe "#belongs_to_rsp" do
        it "returns false for a domain that is not owned by the rsp" do
          VCR.use_cassette("lookup/belongs_to_rsp") do
            res = @opensrs.belongs_to_rsp?('example.com')
            res.result['belongs_to_rsp'].to_i.should == 0
          end
        end

        it "returns true for a domain owned by the rsp" do
          VCR.use_cassette("lookup/belongs_to_rsp_negative") do
            res = @opensrs.belongs_to_rsp?(@registered_domain)
            res.result['belongs_to_rsp'].to_i.should == 1
          end
        end
      end

      describe "#get_balance" do
        use_vcr_cassette "lookup/get_balance"

        it "returns the balance" do
          res = @opensrs.get_balance
          res.result['balance'].to_f.should == 7312.24
          res.result['hold_balance'].to_f.should == 11.44
        end
      end

      describe "#get_deleted_domains" do
        use_vcr_cassette "lookup/get_deleted_domains"

        it "returns domains that have been deleted" do
          result = @opensrs.get_deleted_domains.result
          result['total'].to_i.should == 2
          result['del_domains']['0']['name'].should == "example.com"
          result['del_domains']['0']['delete_date_epoch'].should == "1294426313"
          result['del_domains']['0']['expiredate_epoch'].should == "1325980310"
        end
      end

      describe "#get domain" do
        it "returns all the info" do
          VCR.use_cassette("lookup/get_domain") do
            res = @opensrs.set_cookie(:username => MooMoo.config.user,
                                      :password => MooMoo.config.pass,
                                      :domain => @registered_domain)
            result = @opensrs.get_domain(:cookie => res.result['cookie']).result
            result['auto_renew'].to_i.should == 1
            result['contact_set']['admin']['org_name'].should == "Example Inc."
            result['nameserver_list']['0']['name'].should == "ns2.systemdns.com"
          end
        end
      end

      describe "#get_domains_contacts" do
        it "returns the domain's contacts" do
          VCR.use_cassette("lookup/get_domains_contacts") do
            result = @opensrs.get_domains_contacts(@registered_domain).result
            result[@registered_domain]['contact_set']['owner']['address2'].should == "Suite 500"
            result[@registered_domain]['contact_set']['billing']['org_name'].should == "Example Inc."
          end
        end

        it "fails for a domain that is not in the registry" do
          VCR.use_cassette("lookup/get_domains_contacts_fail") do
            res = @opensrs.get_domains_contacts('example.com')
            res.success?.should be_true
            res.result['example.com']['error'].should match(/Domain does not belong to the reseller/i)
          end
        end
      end

      describe "#get_domains_by_expiredate" do
        use_vcr_cassette "lookup/get_domains_by_expiredate"

        it "requires a start date", :wip => true do
          requires_attr(:start_date) { @opensrs.get_domains_by_expiredate(:end_date => Date.parse('2011-04-21')) }
        end

        it "requires an end date", :wip => true do
          requires_attr(:end_date) { @opensrs.get_domains_by_expiredate(:start_date => Date.parse('2011-04-21')) }
        end

        it "returns domains within an expiration range" do
          result = @opensrs.get_domains_by_expiredate(
            :start_date => Date.parse('2011-04-21'), 
            :end_date => Date.parse('2011-04-21') + 365
          ).result
          result['total'].to_i.should == 2
          result['exp_domains']['0']['name'].should == "example.com"
          result['exp_domains']['0']['f_auto_renew'].should == "N"
          result['exp_domains']['0']['f_let_expire'].should == "N"
          result['exp_domains']['0']['expiredate'].should == "2011-11-03 16:14:46"
        end
      end

      describe "#get_notes" do
        it "returns the notes for a domain" do
          VCR.use_cassette("lookup/get_notes_for_domain") do
            result = @opensrs.get_notes_for_domain(@registered_domain).result
            result['total'].to_i.should == 4
            result['notes']['1']['note'].should match(/Order.*?\d+.*?Domain Registration.*?1 year/i)
          end
        end

        it "returns the notes for an order" do
          VCR.use_cassette("lookup/get_notes_for_order") do
            result = @opensrs.get_notes_for_order(:domain => @registered_domain, :order_id => 1855625).result
            result['page'].to_i.should == 1
            result['notes'].should be_a_kind_of(Hash)
            result['notes'].should be_empty
          end
        end

        it "returns the notes for a transfer" do
          VCR.use_cassette("lookup/get_notes_for_transfer") do
            res = @opensrs.get_notes_for_transfer(:domain => "testingdomain.com", :transfer_id => 37021)
            res.success?.should be_true
          end
        end
      end

      describe "#get_order_info" do
        use_vcr_cassette "lookup/get_order_info"

        it "returns the order info" do
          result = @opensrs.get_order_info(1855625).result['field_hash']
          result['owner_address2'].should == "Suite 500"
          result['billing_org_name'].should == "Example Inc."
          result['period'].to_i.should == 1
        end
      end

      describe "#get_orders_by_domain" do
        use_vcr_cassette "lookup/get_orders_by_domain"

        it "returns the orders for a domain" do
          result = @opensrs.get_orders_by_domain(@registered_domain).result
          result['orders'].should be_a_kind_of(Hash)
          result['orders'].should have(2).domains
          result['orders']['0']['id'].to_i.should == 1862773
        end
      end

      describe "#get_price" do
        use_vcr_cassette "lookup/get_price"

        it "returns the price" do
          res = @opensrs.get_price('example.com')
          res.result['price'].to_f.should == 11.62
        end
      end

      describe "#get_product_info" do
        use_vcr_cassette "lookup/get_product_info"

        it "fails to find an invalid product" do
          res = @opensrs.get_product_info(99)
          res.success?.should be_false
          res.error_code.should == 405
          res.error_msg.should match(/cannot be found/i)
        end
      end

      describe "#lookup domain" do
        it "returns the availbility of an available domain" do
          VCR.use_cassette("lookup/lookup_domain_available") do
            result = @opensrs.lookup_domain('example.com').result
            result['status'].should == "available"
          end
        end

        it "returns the availability of a registered domain" do
          VCR.use_cassette("lookup/lookup_domain_registered") do
            result = @opensrs.lookup_domain(@registered_domain).result
            result['status'].should == "taken"
          end
        end
      end

      describe "#name_suggest" do
        use_vcr_cassette "lookup/name_suggest"

        it "returns suggested names for a domain" do
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
