require 'spec_helper'

describe MooMoo::Cookie do
  before(:each) do
    @opensrs = MooMoo::Cookie.new
    @registered_domain = "domainthatsnottaken1302209138.com"
  end

  describe "#set_cookie" do
    it "sets the cookie" do
      VCR.use_cassette("cookie/set_cookie") do
        res = @opensrs.set_cookie(
          :username => MooMoo.config.user,
          :password => MooMoo.config.pass,
          :domain   => @registered_domain
        )
        res.success?.should be_true
        res.result['cookie'].should == "0000000000000000:000000:00000"
      end
    end

    it "fails to set the cookie" do
      VCR.use_cassette("cookie/set_cookie_fail") do
        res = @opensrs.set_cookie(
          :username => MooMoo.config.user,
          :password => 'password',
          :domain   => 'example.com'
        )
        res.success?.should be_false
        res.error_code.should == 415
      end
    end
  end

  describe "#delete_cookie" do
    use_vcr_cassette "cookie/delete_cookie"

    it "destroys the cookie" do
      res = @opensrs.set_cookie(
        :username => MooMoo.config.user,
        :password => MooMoo.config.pass,
        :domain   => @registered_domain
      )
      res = @opensrs.delete_cookie(res.result['cookie'])
      res.success?.should be_true
    end
  end

  describe "#update_cookie" do
    use_vcr_cassette "cookie/update_cookie"

    it "updates the cookie's domain" do
      res = @opensrs.set_cookie(
        :username => MooMoo.config.user,
        :password => MooMoo.config.pass,
        :domain   => @registered_domain
      )
      res = @opensrs.update_cookie(
        :old_domain => @registered_domain,
        :new_domain => @registered_domain,
        :cookie     => res.result['cookie']
      )
      res.success?.should be_true
      res.result['domain_count'].to_i.should == 1
    end
  end

  describe "#quit_session" do
    use_vcr_cassette "cookie/quit_session"

    it "quits the session" do
      res = @opensrs.quit_session
      res.success?.should be_true
    end
  end
end
