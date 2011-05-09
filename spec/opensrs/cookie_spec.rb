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

    describe "Cookie Commands" do
      describe "set_cookie" do
        use_vcr_cassette "cookie/set_cookie"

        it "should set the cookie" do
          res = @opensrs.set_cookie(@opensrs_user, @opensrs_pass, @registered_domain)
          res.success?.should be_true
          res.result['cookie'].should == "0000000000000000:000000:00000"
        end
      end

      describe "delete_cookie" do
        use_vcr_cassette "cookie/delete_cookie"
        
        it "should destroy the cookie" do
          res = @opensrs.set_cookie(@opensrs_user, @opensrs_pass, @registered_domain)
          res = @opensrs.delete_cookie(res.result['cookie'])
          res.success?.should be_true
        end
      end

      describe "update_cookie" do
        use_vcr_cassette "cookie/update_cookie"

        it "should update the cookie's domain" do
          res = @opensrs.set_cookie(@opensrs_user, @opensrs_pass, @registered_domain)
          res = @opensrs.update_cookie(@registered_domain, @registered_domain, res.result['cookie'])
          res.success?.should be_true
          res.result['domain_count'].to_i.should == 1
        end
      end

      describe "quit_session" do
        use_vcr_cassette "cookie/quit_session"

        it "should quit the session" do
          res = @opensrs.quit_session
          res.success?.should be_true
        end
      end
    end

  end
end
