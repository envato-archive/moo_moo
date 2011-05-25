module MooMoo
  class OpenSRS
    module ProvisioningCommands
      # Cancels a Trust Service order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the order
      def cancel_order(order_id)
        try_opensrs do
          cmd = Command.new('cancel_order', 'trust_service', {"order_id" => order_id})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Cancels pending or declined orders
      #
      # ==== Required
      #  * <tt>:to_date</tt> - date before which to cancel orders
      def cancel_pending_orders(to_date)
        try_opensrs do
          cmd = Command.new('cancel_pending_orders', 'order', {"to_date" => to_date})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Changes information associated with a domain
      #
      # ==== Required
      #  * <tt>:type</tt> - type of data to modify
      #  * <tt>:params</tt> - new parameter values to set
      #
      # ==== Optional
      #  * <tt>:cookie</tt> - cookie for the domain
      def modify(type, params, cookie = nil)
        try_opensrs do
          cmd = Command.new('modify', 'domain', {"data" => type}.merge(params), cookie)
          result = run_command(cmd)

          Response.new(result)
        end
      end

      # Processes or cancels a pending order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the pending order to process
      def process_pending(order_id)
        try_opensrs do
          cmd = Command.new('process_pending', 'domain', {"order_id" => order_id})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Renews a domain name
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to renew
      #  * <tt>:term</tt> - number of years to renew for
      #  * <tt>:current_expiration_year</tt> - current expiration year in YYYY format
      def renew_domain(attribs)
        try_opensrs do
          cmd = Command.new('renew', 'domain', {
            :domain => attribs[:domain], 
            "period" => attribs[:term], 
            "currentexpirationyear" => attribs[:current_expiration_year], 
            "handle" => "process"
          })
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Removes the domain at the registry
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to remove
      #  * <tt>:reseller</tt> - username of the reseller
      def revoke(domain, reseller)
        try_opensrs do
          cmd = Command.new('revoke', 'domain', {"domain" => domain, "reseller" => reseller})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Submits a domain contact information update
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to update the contacts of
      #  * <tt>:contacts</tt> - contact set with updated values
      #  * <tt>:types</tt> - list of contact types that are to be updated
      def update_contacts(domain, contacts, types)
        try_opensrs do
          types = index_array(types)
          cmd = Command.new('update_contacts', 'domain', {"domain" => domain, "contact_set" => contacts, "types" => types})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Submits a new registration request or transfer order
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to register
      #  * <tt>:contacts</tt> - contact set for the domain
      #  * <tt>:nameservers</tt> - array of nameservers
      #
      # ==== Optional
      #  * <tt>:term</tt> - number of years to register the domain for
      #  * <tt>:options</tt> - additional attributes to set
      def register_domain(attribs)
        try_opensrs do
          attribs[:term] = 1 unless attribs[:term]
          nameservers = format_nameservers(attribs[:nameservers])

          attributes = {
            :contact_set => attribs[:contacts],
            :custom_nameservers => 1,
            :custom_tech_contact => 1,
            :domain => attribs[:domain],
            :nameserver_list => nameservers,
            :period => attribs[:term],
            :reg_username => @user,
            :reg_password => @password
          }

          attributes[:reg_type] = :new unless attribs[:options] && attribs[:options][:reg_type]
          attributes.merge!(attribs[:options]) if attribs[:options]

          cmd = Command.new('sw_register', 'domain', attributes)

          register(cmd)
        end
      end

      # Submits a new registration request or transfer order
      #
      # ==== Required
      #  * <tt>:csr</tt> - certificate signing request
      #  * <tt>:contacts</tt> - contact set for the trust service
      #
      # ==== Optional
      #  * <tt>:attribs</tt> - additional attributes to set
      #  * <tt>:term</tt> - number of years to register the trust service for
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

      private

      # Submits a new registration request or transfer order
      #
      # ==== Required
      #  * <tt>:cmd</tt> - command to run
      def register(cmd)
        try_opensrs do
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      private

      def format_nameservers(nameservers)
        [
          "0".to_sym => {
            :sortorder => 1,
            :name => nameservers.first
          },
          "1".to_sym => {
            :sortorder => 2,
            :name => nameservers.size == 2 ? nameservers[1] : nameservers.first
          },
        ]
      end
    end
  end
end
