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

          result['attributes']
        end
      end

      def renew_domain(domain, term)
        try_opensrs do
          # TODO: get the expiration year
          expire_year = 2011
          cmd = Command.new('renew', 'domain', {"domain" => domain, "period" => term, "currentexpirationyear" => expire_year, "handle" => "process"})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def revoke(domain, reseller)
        try_opensrs do
          cmd = Command.new('revoke', 'domain', {"domain" => domain, "reseller" => reseller})
          result = run_command(cmd)
        end
      end

      def register(cmd)
        try_opensrs do
          begin
            result = run_command(cmd)

            p result.inspect

            success = result['is_success'].to_i == 1
            order_id = result['attributes']['id'].to_i
            #::DomainRegistry::DomainOrder.new(success, order_id)
          rescue OpenSRSException => e
          end

          result['attributes']
        end
      end

      def update_contacts(domain, contacts, types)
        try_opensrs do
          types = index_array(types)
          cmd = Command.new('update_contacts', 'domain', {"domain" => domain, "contact_set" => contacts, "types" => types})
          result = run_command(cmd)

          result['attributes']['details']
        end
      end

      def register_domain(domain, contacts, term = 1, attribs = {})
        try_opensrs do

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

          attributes = {
            "contact_set" => contacts, 
            "custom_nameservers" => 1, 
            "custom_tech_contact" => 1, 
            "domain" => domain, 
            "nameserver_list" => nameservers, 
            "period" => term, 
            "reg_type" => "new", 
            "reg_username" => @user, 
            "reg_password" => @password
          }

          cmd = Command.new('sw_register', 'domain', attributes.merge(attribs))

          register(cmd)
        end
      end

      def register_trust_service(csr, contacts, attributes, term = 1)
        try_opensrs do

          attribs = {
            "contact_set" => contacts,
            "csr" => csr,
            "period" => term,
            "reg_type" => "new",
            "handle" => "process",
            #"reg_username" => @user,
            #"reg_password" => @password
          }

          cmd = Command.new('sw_register', 'trust_service', attribs.merge(attributes))

          register(cmd)
        end
      end
    end
  end
end
