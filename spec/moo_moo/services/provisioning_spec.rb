require 'spec_helper'
require 'date'

describe MooMoo::Provisioning do
  subject { MooMoo::Provisioning.new }

  let(:success_response) do
    double("Response", :body => { "is_success" => "1" })
  end

  it { should have_registered_service(:cancel_order, :trust_service) }
  it { should have_registered_service(:cancel_pending_orders, :order) }
  it { should have_registered_service(:modify, :domain) }
  it { should have_registered_service(:process_pending, :domain) }
  it { should have_registered_service(:renew, :domain) }
  it { should have_registered_service(:revoke, :domain) }
  it { should have_registered_service(:update_contacts, :domain) }
  it { should have_registered_service(:sw_register, :domain) }
  it { should have_registered_service(:register_trust_service, :trust_service) }

  describe "#update_contact" do
    it "updates a domain contact" do
      expected_params = {
        :domain => "thedomain.com",
        :attributes => {
          :affect_domains => "0",
          :data => "contact_info",
          :contact_set => {
            "admin" => {
              :first_name  => "AdminFirst",
              :last_name   => "AdminLast",
              :org_name    => "AdminOrg",
              :address1    => "AdminAddress1",
              :address2    => "AdminAddress2",
              :address3    => "AdminAddress3",
              :city        => "AdminCity",
              :state       => "AdminState",
              :country     => "AdminCountry",
              :postal_code => "AdminPostalCode",
              :phone       => "AdminPhone",
              :fax         => "AdminFax",
              :email       => "AdminEmail"
            }
          }
        }
      }

      params = {
        :type        => "admin",
        :first_name  => "AdminFirst",
        :last_name   => "AdminLast",
        :org_name    => "AdminOrg",
        :address1    => "AdminAddress1",
        :address2    => "AdminAddress2",
        :address3    => "AdminAddress3",
        :city        => "AdminCity",
        :state       => "AdminState",
        :country     => "AdminCountry",
        :postal_code => "AdminPostalCode",
        :phone       => "AdminPhone",
        :fax         => "AdminFax",
        :email       => "AdminEmail"
      }

      subject.should_receive(:faraday_request).with(:modify, :domain, expected_params).and_return(success_response)
      subject.update_contact("thedomain.com", params)

      subject.should be_successful
    end

    it "is unsuccessful when fails" do
      expected_params = {
        :domain => "thedomain.com",
        :attributes => {
          :affect_domains => "0",
          :data => "contact_info",
          :contact_set => { nil => {}}
        }
      }

      error_response = double("Response", :body => {
        "attributes" => {
          "details" => {
            "thedomain.com" => {
              "response_text" => "The error\nAnother error"
            }
          }
        }
      })

      subject.should_receive(:faraday_request).with(:modify, :domain, expected_params).and_return(error_response)
      errors = subject.update_contact("thedomain.com", {})

      subject.should_not be_successful
      errors.should == ["The error", "Another error"]
    end
  end
end