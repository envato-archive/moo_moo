require 'spec_helper'
require 'moomoo/opensrs'

module MooMoo

  describe OpenSRS do
    before(:each) do
      def random_domain
        "domainthatsnottaken#{Time.now.to_i}.com"
      end

      @opensrs = OpenSRS.new(@opensrs_host, @opensrs_key, @opensrs_user, @opensrs_pass)
    end

    describe "OpenSRS" do
      it "should use the default port" do
        @opensrs = OpenSRS.new(@opensrs_host, @opensrs_key, @opensrs_user, @opensrs_pass)
        @opensrs.port.should == 55443
      end
    end

    describe "can register?" do
      it "should return true for a valid, available domain" do
        VCR.use_cassette('can_register', :match_requests_on => [:method, :uri, :body]) do
          result = @opensrs.can_register?('opensrsgemtestingdomain.com')
          result.should be_true
        end
      end

      it "should raise an exception for an invalid domain" do
        VCR.use_cassette('can_register', :match_requests_on => [:method, :uri, :body]) do
          expect { @opensrs.can_register?('example') }.to raise_error(OpenSRSException, /unexpected/i)
        end
      end

      it "should return false for an unavailable domain" do
        VCR.use_cassette('can_register', :match_requests_on => [:method, :uri, :body]) do
          result = @opensrs.can_register?('example.com')
          result.should be_false
        end
      end
    end

    describe "can register list?" do
      it "return a boolean for each domain" do
        VCR.use_cassette('can_register_list', :match_requests_on => [:method, :uri, :body]) do
          result = @opensrs.can_register_list?('example.com', random_domain, random_domain)
          result.should == [false, true, true]
        end
      end
    end

    describe "can transfer?", :wip => true do
      it "should return true if the domain can be transferred" do
        VCR.use_cassette('can_register_list', :match_requests_on => [:method, :uri, :body]) do
          domain = random_domain
          @opensrs.register(domain)
          result = @opensrs.can_transfer?(domain)
          result.should be_true
        end
      end

      it "should return false if the domain can't be transferred" do
        VCR.use_cassette('can_register_list', :match_requests_on => [:method, :uri, :body]) do
          result = @opensrs.can_transfer?('example.com')
          result.should be_false
        end
      end
    end

    describe "register" do
      it "should register a domain that is available" do
        VCR.use_cassette('register', :match_requests_on => [:method, :uri, :body]) do
          result = @opensrs.register(random_domain)
          result["is_success"].to_i.should == 1 
          result["response_code"].to_i.should == 200 
        end
      end

      it "should not register a domain that is not available" do
        VCR.use_cassette('register', :match_requests_on => [:method, :uri, :body]) do
          result = @opensrs.register('example.com')
          result["is_success"].to_i.should == 0 
          result["response_code"].to_i.should == 485 
        end
      end
    end
  end
end
