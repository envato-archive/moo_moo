require 'spec_helper'
require 'date'

describe MooMoo::Lookup do
  subject { MooMoo::Lookup.new }

  it { should have_registered_service(:belongs_to_rsp, :domain) }
  it { should have_registered_service(:get_balance, :balance) }
  it { should have_registered_service(:get_deleted_domains, :domain) }
  it { should have_registered_service(:get, :domain) }
  it { should have_registered_service(:get_domains_by_expiredate, :domain) }
  it { should have_registered_service(:get_domains_contacts, :domain) }
  it { should have_registered_service(:get_notes, :domain) }
  it { should have_registered_service(:get_order_info, :domain) }
  it { should have_registered_service(:get_orders_by_domain, :domain) }
  it { should have_registered_service(:get_price, :domain) }
  it { should have_registered_service(:get_product_info, :trust_service) }
  it { should have_registered_service(:lookup, :domain) }
  it { should have_registered_service(:name_suggest, :domain) }

  describe "#get_domains_contacts" do
    it "retrieves a list of a domain contacts" do
      subject.should_receive(:faraday_request).with(:get_domains_contacts, :domain, { :attributes => { :domain_list => ["domain1.com"] }}).and_return(double("Response", :body => {
         "attributes" => {
            "domain1.com" => {
              "contact_set" => {
                "admin" => {
                  "first_name"  => "FirstName",
                  "last_name"   => "LastName",
                  "org_name"    => "OrgName",
                  "address1"    => "Address1",
                  "address2"    => "Address2",
                  "address3"    => "Address3",
                  "city"        => "City",
                  "state"       => "State",
                  "country"     => "Country",
                  "postal_code" => "PostalCode",
                  "phone"       => "Phone",
                  "fax"         => "Fax",
                  "email"       => "Email"
                }
              }
            }
          }
       }))

      subject.domain_contacts("domain1.com").should ==
        [
          {
            :type =>        "admin",
            :first_name =>  "FirstName",
            :last_name =>   "LastName",
            :org_name =>    "OrgName",
            :address1 =>    "Address1",
            :address2 =>    "Address2",
            :address3 =>    "Address3",
            :city =>        "City",
            :state =>       "State",
            :country =>     "Country",
            :postal_code => "PostalCode",
            :phone =>       "Phone",
            :fax =>         "Fax",
            :email =>       "Email"
          }
        ]
    end
  end

  describe "#tlds" do
    it "lists top level domains opensrs supports" do
      subject.tlds.should == YAML.load_file(MooMoo::Lookup::TLDS_FILE)
    end
  end
end