module MooMoo
  class OpenSRS
    module ProvisioningCommands
      # Cancels a Trust Service order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the order
      def cancel_order(order_id)
        run_command :cancel_order, :trust_service, {
          :order_id => order_id,
          :key => 'attributes'
        }
      end

      # Cancels pending or declined orders
      #
      # ==== Required
      #  * <tt>:to_date</tt> - date before which to cancel orders
      def cancel_pending_orders(to_date)
        run_command :cancel_pending_orders, :order, {
          :to_date => to_date,
          :key => 'attributes'
        }
      end

      # Changes information associated with a domain
      #
      # ==== Required
      #  * <tt>:type</tt> - type of data to modify
      #  * <tt>:params</tt> - new parameter values to set
      #
      # ==== Optional
      #  * <tt>:cookie</tt> - cookie for the domain
      def modify(params)
        cookie = params.delete :cookie

        run_command :modify, :domain, params, cookie
      end

      # Processes or cancels a pending order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the pending order to process
      def process_pending(order_id)
        run_command :process_pending, :domain, {
          :order_id => order_id,
          :key => 'attributes'
        }
      end

      # Renews a domain name
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to renew
      #  * <tt>:term</tt> - number of years to renew for
      #  * <tt>:current_expiration_year</tt> - current expiration year in YYYY format
      def renew_domain(attribs)
        Args.new(attribs) do |c|
          c.requires :domain, :term, :current_expiration_year
        end

        attribs[:handle] = 'process' unless attribs[:handle]
        attribs[:key] = 'attributes'

        run_command :renew, :domain, attribs
      end

      # Removes the domain at the registry
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to remove
      #  * <tt>:reseller</tt> - username of the reseller
      def revoke(params)
        params[:key] = 'attributes'

        run_command :revoke, :domain, params
      end

      # Submits a domain contact information update
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to update the contacts of
      #  * <tt>:contacts</tt> - contact set with updated values
      #  * <tt>:types</tt> - list of contact types that are to be updated
      def update_contacts(params)
        types = index_array(params[:types])

        params[:contact_set] = params.delete :contacts
        params[:key] = 'attributes'

        run_command :update_contacts, :domain, params      end

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
        Args.new(attribs) do |c|
          c.requires :domain, :contacts, :nameservers
          c.optionals :term, :options
        end

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
        attributes[:key] = 'attributes'

        res = run_command :sw_register, :domain, attributes
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
      def register_trust_service(params)
        params[:period] = params.delete :term
        params[:period] = 1 unless params[:period]
        params[:reg_type] = 'new' unless params[:reg_type]
        params[:handle] = 'process' unless params[:handle]
        params[:contact_set] = params.delete :contacts
        params[:key] = 'attributes'

        run_command :sw_register, :trust_service, params
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
