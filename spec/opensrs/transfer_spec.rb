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
      @contacts = {
            :title => "blahblah",
            :owner => {
              :first_name => "Owen",
              :last_name => "Ottway",
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
              :first_name => "Owen",
              :last_name => "Ottway",
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
              :first_name => "Owen",
              :last_name => "Ottway",
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
              :first_name => "Owen",
              :last_name => "Ottway",
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
    end

    describe "Transfer Commands" do
      describe "cancel_transfer" do
        it "should cancel the transfer for a domain" do
          VCR.use_cassette("transfer/cancel_transfer") do
            res = @opensrs.cancel_transfer('exampledomain.com', @opensrs_user)
            res.success?.should be_false
            res.error_code.should == 400
            res.error_msg.should match(/transfer state prohibits cancellation/i)
          end
        end

        it "should cancel the transfer for an order" do
          VCR.use_cassette("transfer/cancel_trasnfer_order") do
            res = @opensrs.cancel_transfer_for_order(1884820, @opensrs_user)
            res.success?.should be_false
            res.error_code.should == 400
            res.error_msg.should match(/transfer state prohibits cancellation/i)
          end
        end
      end

      describe "check_transfer" do
        it "should show in progress if the transfer is in progress" do
          VCR.use_cassette("transfer/check_transfer") do
            res = @opensrs.check_transfer('exampledomain.com')
            res.result['transferrable'].to_i.should == 0
            res.result['reason'].should match(/Transfer in progress/i)
          end
        end

        it "should say the domain already exists if it does" do
          VCR.use_cassette("transfer/check_transfer_exists") do
            res = @opensrs.check_transfer(@registered_domain)
            res.result['transferrable'].to_i.should == 0
            res.result['reason'].should match(/Domain already exists in.*account/i)
          end
        end
      end

      describe "get_transfers_away" do
        use_vcr_cassette "transfer/get_transfers_away"

        it "should list domains that have been transferred away" do
          res = @opensrs.get_transfers_away
          res.result['total'].to_i.should == 0
        end
      end

      describe "get_tranfers_in" do
        use_vcr_cassette "transfer/get_transfers_in"

        it "should list domains that have been transferred in" do
          res = @opensrs.get_transfers_in
          res.result['total'].to_i.should == 1
          res.result['transfers']['0']['domain'].should == "testingdomain.com"
        end
      end

      describe "process_transfer" do
        use_vcr_cassette "transfer/process_transfer"

        it "should do a new order with cancelled order's data" do
          res = @opensrs.register_domain('fds23afafdsajfkdajfkljfklajfdkljflaexample.com', @contacts, ["ns1.systemdns.com", "ns2.systemdns.com"], 1, {"handle" => "save"})
          result = @opensrs.process_transfer(res.result['id'].to_i, @opensrs_user)
          pending "needs some fixing"
        end
      end

      describe "send_password (transfer)" do
        use_vcr_cassette "transfer/send_password"

        it "should resend email message to admin contact" do
          result = @opensrs.send_password('fdsafsfsafafsaexample.com')
        end
      end

      describe "push_transfer" do
        use_vcr_cassette "transfer/rsp2rsp_push_transfer"

        it "should transfer the domain" do
          res = @opensrs.push_transfer(@registered_domain, @opensrs_user, @opensrs_pass, "opensrs")
          res.success?.should be_false
          res.error_code.should == 465
          res.error_msg.should match(/transfer permission denied/i)
        end
      end

      describe "transfer" do
        use_vcr_cassette "transfer/transfer"

        it "should initiate the transfer" do
          res = @opensrs.register_domain('testingdomain.com', @contacts, ["ns1.systemdns.com", "ns2.systemdns.com"], 1, {"reg_type" => "transfer"})
          res.success?.should be_true
          res.result['id'].to_i.should == 1885789
          res.result['registration_text'].should match(/transfer request initiated/i)
        end
      end
    end
  end
end
