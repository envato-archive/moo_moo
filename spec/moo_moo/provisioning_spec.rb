require 'spec_helper'
require 'date'

describe MooMoo::Provisioning do
  before(:each) do
    @opensrs = MooMoo::Provisioning.new
    @registered_domain = "domainthatsnottaken1302209138.com"
    @contacts = test_contacts
  end

  describe "#cancel_order" do
    it "cancels a trust service order" do
      VCR.use_cassette("provisioning/cancel_order") do
        res = @opensrs.cancel_order(123456)
        res.success?.should be_true
        res.result['order_id'].to_i.should == 123456
        res.result['domain'].should == "example.com"
      end
    end

    it "doesn't cancel an invalid trust service order" do
      VCR.use_cassette("provisioning/cancel_order_invalid") do
        res = @opensrs.cancel_order(111111)
        res.success?.should be_false
        res.error_code.should == 405
      end
    end
  end

  describe "#cancel_pending_orders" do
    use_vcr_cassette "provisioning/cancel_pending_orders"

    it "cancels all pending orders" do
      result = @opensrs.cancel_pending_orders(1302890914).result
      result['total'].to_i.should == 0
      result['cancelled'].should be_a_kind_of(Hash)
      result['cancelled'].should be_empty
    end
  end

  describe "#modify domain" do
    it "updates the contact information" do
    end

    it "updates the expire action" do
      VCR.use_cassette("provisioning/modify_domain") do
        res = @opensrs.modify({:type => 'expire_action', :domain => @registered_domain, :auto_renew => 1, :let_expire => 0})
        res.success?.should be_true
      end
    end

    it "modifies all domains linked to the profile" do
      VCR.use_cassette("provisioning/modify_all_domains") do
        res = @opensrs.modify({
          :type => 'expire_action',
          :affect_domains => 1,
          :auto_renew => 0,
          :let_expire => 1,
          :cookie => "0000000000000000:000000:00000"})
        res.success?.should == true
      end
    end
  end

  describe "#process_pending" do
    use_vcr_cassette "provisioning/process_pending"

    it "processes the pending order" do
      result = @opensrs.process_pending(1878084).result
      result['order_id'].to_i.should == 1878084
      result['id'].to_i.should == 730001
      result['f_auto_renew'].should == "Y"
    end
  end

  describe "#renew_domain" do
    use_vcr_cassette "provisioning/renew_domain"

    it "requires a domain", :wip => true do
      requires_attr(:domain) { @opensrs.renew_domain(:term => 1, :current_expiration_year => 2011) }
    end

    it "requires a term", :wip => true do
      requires_attr(:term) { @opensrs.renew_domain(:domain => 'example.com', :current_expiration_year => 2011) }
    end

    it "requires a current_expiration_year", :wip => true do
      requires_attr(:current_expiration_year) { @opensrs.renew_domain(:domain => 'example.com', :term => 1) }
    end

    it "renews the domain" do
      result = @opensrs.renew_domain(
        :domain => "example.com",
        :term => 1,
        :current_expiration_year => 2011
      ).result
      result['order_id'].to_i.should == 1867227
      result['id'].to_i.should == 678899
      result['admin_email'].should == "adams@example.com"
    end
  end

  describe "#revoke domain" do
    use_vcr_cassette "provisioning/revoke_domain"

    it "removes the domain from the registry" do
      res = @opensrs.revoke(:domain => "example.com", :reseller => MooMoo.config.user)
      res.success?.should be_true
      res.result['charge'].to_i.should == 1
    end
  end

  describe "#register" do
    it "requires a domain", :wip => true do
      requires_attr(:domain) { @opensrs.register_domain(:contacts => @contacts, :nameservers => ['ns1.blah.com']) }
    end

    it "requires a contacts", :wip => true do
      requires_attr(:contacts) { @opensrs.register_domain(:domain => 'example.com', :nameservers => []) }
    end

    it "requires a nameservers", :wip => true do
      requires_attr(:nameservers) { @opensrs.register_domain(:domain => 'example.com', :contacts => @contacts) }
    end

    it "registers a domain" do
      VCR.use_cassette("provisioning/register_domain") do
        res = @opensrs.register_domain(
          :domain => 'fdsafsfsafafsaexample.com',
          :contacts => @contacts,
          :nameservers => ["ns1.systemdns.com", "ns2.systemdns.com"],
          :term => 1)
        result = res.result
        result['registration_text'].should match(/successfully completed/i)
        result['id'].to_i.should == 1885783
      end
    end

    it "registers a pending domain registration" do
      VCR.use_cassette("provisioning/register_pending_domain") do
        res = @opensrs.register_domain(
          :domain => 'fdsajfkdajfkljfklajfdkljflaexample.com',
          :contacts => @contacts,
          :nameservers => ["ns1.systemdns.com", "ns2.systemdns.com"],
          :term => 1,
          :options => {:handle => :save})
        res.success?.should be_true
        res.result['id'].to_i.should == 1888032
      end
    end

    it "registers a domain transfer" do
      VCR.use_cassette("transfer/transfer") do
        res = @opensrs.register_domain(
          :domain      => 'testingdomain.com',
          :contacts    => @contacts,
          :nameservers => ["ns1.systemdns.com", "ns2.systemdns.com"],
          :term        => 1,
          :options     => { :reg_type => :transfer }
        )
        res.success?.should be_true
        res.result['id'].to_i.should == 1885789
        res.result['registration_text'].should match(/transfer request initiated/i)
      end
    end

    it "fails if the domain is taken" do
      VCR.use_cassette("provisioning/register_taken_domain") do
        res = @opensrs.register_domain(
          :domain => 'example.com',
          :contacts => @contacts,
          :nameservers => ["ns1.systemdns.com", "ns2.systemdns.com"],
          :term => 1)
        res.success?.should be_false
      end
    end
  end

  describe "#register_trust_service" do
    use_vcr_cassette "provisioning/trust_service"

    it "registers the trust service" do
      csr = "-----BEGIN CERTIFICATE REQUEST----- MIIC4TCCAckCAQAwgZsxKTAnBgNVBAMTIHNlY3VyZXNpdGUudGVzdDEyODU4NzYwMzY2MDgub3JnMQswCQYDVQQGEwJDQTELMAkGA1UECBMCT04xEDAOBgNVBAcTB1Rvcm9udG8xDzANBgNVBAoTBm5ld29yZzEPMA0GA1UECxMGUUFEZXB0MSAwHgYJKoZIhvcNAQkBFhFxYWZpdmVAdHVjb3dzLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ0FDLurKaddUzayM5FgICBhy8DkOaBuYzCiHSFw6xRUf9CjAHpC/MiUM5TnegMiU02COAPmfeHZAERv21CoB/HPDcshewHJywzs8nwcbGncz37eFhNGFQNIif5ExoGAcLS9+d1EAmR1CupTBCCq86lGBa/RdwgUNlvLF5IgZZeKphd/FKaYB2KZmRBxM51WvV6AYmRKb6IsuUZCfHO2FCelThDE0EF99GbfSapVj7woSIu0/PTJcEX4sHURq6pY3ELfNG0BOzrTsT3Af8T3N5xwD0FMatkDrCPCgVx7sRZ05UqenxBOVWBJQcr5QRZSykxBosGjbqO3QSyGsElIKgkCAwEAAaAAMA0GCSqGSIb3DQEBBAUAA4IBAQCEUGNk45qCJiR4Yuce4relbP22EwK7pyX0+0VZ+F3eUxhpZ6S5WN1Juuru8w48RchQBjGK1jjUfXJIqn/DgX+yAfMj4aW/ohBmovN2ViuNILvNaj0volwoqyMlNrTmBze69qHMfnMGUUUehMr/Nq4QdQTqxy7EYQkNOqx21gfZcUi6zWCeFTRkasD+SYAKsOUIKdrt/Jq5lWFXxhkJHuyA+q1yr/w6zh18JmFAT4y/0q/odFGyIr9yKhQ9usW1sQ8CT3e3AnU4jq7sBrYFxN0f+92W8gX7WADortA7+6PcSFPrZEoQlr5Brki7GSwIuTTSlKFRyZ53DbEGjp2ELnnl -----END CERTIFICATE REQUEST----- "
      @contacts.delete(:owner)
      @contacts.delete(:title)
      @contacts[:admin].delete(:url)
      @contacts[:billing].delete(:url)
      @contacts[:tech].delete(:url)
      res = @opensrs.register_trust_service(
        :csr          => csr,
        :contacts     => @contacts,
        :server_type  => 'apachessl',
        :product_type => 'securesite',
        :server_count => 1,
        :term         => 1
      )
      res.success?.should be_false
      res.error_code.should == 501
      res.error_msg.should match(/Permission denied/i)
    end
  end

  describe "#update_contacts" do
    use_vcr_cassette "provisioning/update_contacts"

    it "updates the contacts" do
      res = @opensrs.update_contacts(:domain => @registered_domain, :contacts => @contacts, :types => ["owner", "admin", "billing", "tech"])
      res.success?.should be_true
      res.result['details'][@registered_domain]['response_code'].to_i.should == 200
    end
  end
end
