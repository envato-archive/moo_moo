module MooMoo
  class OpenSRS
    module LookupCommands
      # Determines whether a domain belongs to the reseller
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to check ownership of
      def belongs_to_rsp?(domain)
        run_command :belongs_to_rsp, :domain, {
          :domain => domain,
          :key => 'attributes'
        }
      end

      # Returns the balance of the reseller's account
      #
      def get_balance
        run_command :get_balance, :balance, {
          :key => 'attributes'
        }
      end

      # Lists domains that have been deleted due to expiration or request
      #
      def get_deleted_domains
        run_command :get_deleted_domains, :domain, {
          :key => 'attributes'
        }
      end

      # Queries various types of data associated with a domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to query
      #  * <tt>:cookie</tt> - cookie for the domain
      #
      # ==== Optional
      #  * <tt>:type</tt> - type of query to perform
      def get_domain(params)
        params[:type] = 'all_info' unless params[:type]

        run_command :get, :domain, {
          :type => params[:type],
          :key => 'attributes'
        }, params[:cookie]
      end

      # Queries contact information for a list of domains
      #
      # ==== Required
      #  * <tt>:domains</tt> - domains to get contact information for
      def get_domains_contacts(*domains)
        domain_list = {}
        domains.each_with_index do |domain, index|
          domain_list[index] = domain
        end

        run_command :get_domains_contacts, :domain, {
          :domain_list => domain_list,
          :key => 'attributes'
        }
      end

      # Queries the domains expiring within the specified date range
      #
      # ==== Required
      #  * <tt>:start_date</tt> - beginning date of the expiration range
      #  * <tt>:end_date</tt> - ending date of the expiration range
      def get_domains_by_expiredate(attribs)
        Args.new(attribs) do |c|
          c.requires :start_date, :end_date
        end

        run_command :get_domains_by_expiredate, :domain, {
          :exp_from => attribs[:start_date].to_s,
          :exp_to => attribs[:end_date].to_s,
          :key => 'attributes'
        }
      end

      # Retrieves the domain notes that detail the history of the domain (renewals, transfers, etc.)
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get the notes for
      def get_notes_for_domain(domain)
        run_command :get_notes, :domain, {
          :domain => domain,
          :type => 'domain',
          :key => 'attributes'
        }
      end

      # Retrieves the domain notes based on an order
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get the notes for
      #  * <tt>:order_id</tt> - ID of the order
      def get_notes_for_order(params)
        run_command :get_notes, :domain, {
          :domain => params[:domain],
          :order_id => params[:order_id],
          :type => 'order',
          :key => 'attributes'
        }
      end

      # Retrieves the domain notes based on a transfer ID
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get the notes for
      #  * <tt>:transfer_id</tt> - ID of the transfer
      def get_notes_for_transfer(params)
        run_command :get_notes, :domain, {
          :domain => params[:domain],
          :transfer_id => params[:transfer_id],
          :type => 'transfer',
          :key => 'attributes'
        }
      end

      # Queries all information related to an order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the order
      def get_order_info(order_id)
        run_command :get_order_info, :domain, {
          :order_id => order_id,
          :key => 'attributes'
        }
      end

      # Retrieves information about orders placed for a specific domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get orders for
      def get_orders_by_domain(domain)
        run_command :get_orders_by_domain, :domain, {
          :domain => domain,
          :key => 'attributes'
        }
      end

      # Queries the price of a domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to query the price of
      def get_price(domain)
        run_command :get_price, :domain, {
          :domain => domain,
          :key => 'attributes'
        }
      end

      # Queries the properties of the specified Trust Service product
      #
      # ==== Required
      #  * <tt>:product_id</tt> - ID of the product
      def get_product_info(product_id)
        run_command :get_product_info, :trust_service, {
          :product_id => product_id,
          :key => 'attributes'
        }
      end

      # Determines the availability of a domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to check availability of
      def lookup_domain(domain)
        run_command :lookup, :domain, {
          :domain => domain,
          :key => 'attributes'
        }
      end

      # Provides suggestions for a domain name for the specified TLDs
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain
      #  * <tt>:tlds</tt> - list of TLDs to make suggestions with
      def name_suggest(domain, tlds)
        tlds_indexed = {}
        tlds.each_with_index do |tld, index|
          tlds_indexed[index] = tld
        end

        run_command :name_suggest, :domain, {
          :searchstring => domain,
          :tlds => tlds_indexed,
          :key => 'attributes'
        }
      end
    end
  end
end
