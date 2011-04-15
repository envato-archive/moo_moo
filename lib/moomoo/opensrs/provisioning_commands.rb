module MooMoo
  class OpenSRS
    module ProvisioningCommands
      def cancel_pending_orders(to_date)
        try_opensrs do
          cmd = Command.new('cancel_pending_orders', 'order', {"to_date" => to_date})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def modify(type, params)
        try_opensrs do
          cmd = Command.new('modify', 'domain', {"data" => type}.merge(params))
          result = run_command(cmd)

          result['is_success'].to_i == 1
        end
      end

      def process_pending(order_id)
        try_opensrs do
          cmd = Command.new('process_pending', 'domain', {"order_id" => order_id})
          result = run_command(cmd)

          result
        end
      end

      def renew_domain(domain, term)
        try_opensrs do
          # TODO: get the expiration year
          expire_year = 2011
          cmd = Command.new('renew', 'domain', {"domain" => domain, "period" => term, "currentexpirationyear" => expire_year, "handle" => "process"})
          result = run_command(cmd)
        end
      end

      def revoke(domain, reseller)
        try_opensrs do
          cmd = Command.new('revoke', 'domain', {"domain" => domain, "reseller" => reseller})
          result = run_command(cmd)
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

      def update_contacts(domain, contacts, types)
        try_opensrs do
          types = index_array(types)
          p types.inspect
          cmd = Command.new('update_contacts', 'domain', {"domain" => domain, "contact_set" => contacts, "types" => types})
          result = run_command(cmd)
        end
      end
    end
  end
end
