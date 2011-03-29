require 'moomoo/opensrs/command'
require 'moomoo/opensrs/opensrsexception'
require 'moomoo/opensrs/utils'

module MooMoo
  class OpenSRS
    include Utils

    attr_reader :port

    def initialize(host, key, user, password)
      @host = host
      @key = key
      @user = user
      @password = password
      @port = 55443
    end

    def run_command(command)
      command.run(@host, @key, @user, @port)
    end

    def can_register?(domain)
      try_opensrs do
        cmd = Command.new('lookup', 'domain', {"domain" => domain})
        result = run_command(cmd)

        case result['response_code'].to_i
          when 210
            true
          when 211
            false
          else
            errors = [result['rrptext1']]
            raise OpenSRSException.new(errors), "Unexpected response from domain registry."
        end
      end
    end

    def register(domain, term = 1)
      try_opensrs do
        contacts = {
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


        nameservers = [
          "0".to_sym => {
            :sortorder => 1,
            :name => "ns1.systemdns.com"
            #:name => "dns1.site5.com"
          },
          "1".to_sym => {
            :sortorder => 2,
            :name => "ns2.systemdns.com"
            #:name => "dns2.site5.com"
          },
        ]

        cmd = Command.new('sw_register', 'domain', {
          "contact_set" => contacts, 
          "custom_nameservers" => 1, 
          "custom_tech_contact" => 1, 
          "domain" => domain, 
          "nameserver_list" => nameservers, 
          "period" => term, 
          "reg_type" => "new", 
          "reg_username" => @user, 
          "reg_password" => @password
        })

        begin
          result = run_command(cmd)

          success = result['is_success'].to_i == 1
          order_id = result['attributes']['id'].to_i
          #::DomainRegistry::DomainOrder.new(success, order_id)
        rescue OpenSRSException => e
        end

        result
      end
    end
  end
end
