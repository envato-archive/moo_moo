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

    describe "Provisioning Commands" do
      describe "cancel_order" do
        use_vcr_cassette "provisioning/cancel_order"

        pending "trust service"
      end

      describe "cancel_pending_orders" do
        use_vcr_cassette "provisioning/cancel_pending_orders"

        it "should cancel all pending orders" do
          # TODO: do an pending order and verify it was canceled
          result = @opensrs.cancel_pending_orders(1302890914)
          result['total'].to_i.should == 0
          result['cancelled'].should be_a_kind_of(Hash)
          result['cancelled'].should be_empty
        end
      end

      describe "modify domain" do
        use_vcr_cassette "provisioning/modify_domain"

        it "should update the contact information" do
        end

        it "should update the expire action" do
          result = @opensrs.modify('expire_action', {"domain" => @registered_domain, "auto_renew" => 1, "let_expire" => 0})
          result.should be_true
        end

        it "should modify all domains linked to the profile" do
#          result = @opensrs.modify_all('something', {})
        end
      end

      describe "process_pending" do
        use_vcr_cassette "provisioning/process_pending"

        pending "need a pending order id"
      end

      describe "renew_domain" do
        use_vcr_cassette "provisioning/renew_domain"

        it "should renew" do
          result = @opensrs.renew_domain("example.com", 1)
          result['order_id'].to_i.should == 1867227
          result['id'].to_i.should == 678899
          result['admin_email'].should == "adams@example.com"
        end
      end

      describe "revoke domain" do
        use_vcr_cassette "provisioning/revoke_domain"

        it "should remove the domain from the registry" do
          result = @opensrs.revoke("example.com", @opensrs_user)
          result['is_success'].to_i.should == 1
        end
      end

      describe "register" do
        use_vcr_cassette "provisioning/register"

        it "should register a domain" do
          result = @opensrs.register('example.com', 1)
          result['registration_text'].should match(/successfully completed/i)
          result['id'].to_i.should == 1869406
        end
      end

      describe "update_contacts" do
        use_vcr_cassette "provisioning/update_contacts"

        it "should update the contacts" do
          contacts = {
            :owner => {
              :first_name => "John",
              :last_name => "Doe",
              :phone => "+1.4165550123x1902",
              :fax => "+1.4165550124",
              :email => "ottway@example.com",
              :org_name => "Example Inc.",
              :address1 => "32 Oak Street",
              :address2 => "Suite 500",
              :address3 => "Owner",
              :city => "SomeCity",
              :state => "CA",
              :country => "US",
              :postal_code => "90210",
              :url => "http://www.example.com"
            },
            :admin => {
              :first_name => "John",
              :last_name => "Doe",
              :phone => "+1.4165550123x1902",
              :fax => "+1.4165550124",
              :email => "ottway@example.com",
              :org_name => "Example Inc.",
              :address1 => "32 Oak Street",
              :address2 => "Suite 500",
              :address3 => "Owner",
              :city => "SomeCity",
              :state => "CA",
              :country => "US",
              :postal_code => "90210",
              :url => "http://www.example.com"
            },
            :billing => {
              :first_name => "John",
              :last_name => "Doe",
              :phone => "+1.4165550123x1902",
              :fax => "+1.4165550124",
              :email => "ottway@example.com",
              :org_name => "Example Inc.",
              :address1 => "32 Oak Street",
              :address2 => "Suite 500",
              :address3 => "Owner",
              :city => "SomeCity",
              :state => "CA",
              :country => "US",
              :postal_code => "90210",
              :url => "http://www.example.com"
            },
            :tech => {
              :first_name => "John",
              :last_name => "Doe",
              :phone => "+1.4165550123x1902",
              :fax => "+1.4165550124",
              :email => "ottway@example.com",
              :org_name => "Example Inc.",
              :address1 => "32 Oak Street",
              :address2 => "Suite 500",
              :address3 => "Owner",
              :city => "SomeCity",
              :state => "CA",
              :country => "US",
              :postal_code => "90210",
              :url => "http://www.example.com"
            }
          }

          result = @opensrs.update_contacts(@registered_domain, contacts, ["owner", "admin", "billing", "tech"])
          raise result.inspect
        end
      end
    end
  end
end
