module MooMoo
  class OpenSRS
    module LookupCommands
      # Determines whether a domain belongs to the reseller
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to check ownership of
      def belongs_to_rsp?(domain)
        try_opensrs do
          cmd = Command.new('belongs_to_rsp', 'domain', {"domain" => domain})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Returns the balance of the reseller's account
      #
      def get_balance
        try_opensrs do
          cmd = Command.new('get_balance', 'balance')
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Lists domains that have been deleted due to expiration or request
      #
      def get_deleted_domains
        try_opensrs do
          cmd = Command.new('get_deleted_domains', 'domain')
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Queries various types of data associated with a domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to query
      #  * <tt>:cookie</tt> - cookie for the domain
      #
      # ==== Optional
      #  * <tt>:type</tt> - type of query to perform
      def get_domain(domain, cookie, type = "all_info")
        try_opensrs do
          cmd = Command.new('get', 'domain', {"type" => "all_info"}, cookie)
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Queries contact information for a list of domains
      #
      # ==== Required
      #  * <tt>:domains</tt> - domains to get contact information for
      def get_domains_contacts(*domains)
        try_opensrs do
          domain_list = {}
          domains.each_with_index do |domain, index|
            domain_list[index] = domain
          end

          cmd = Command.new('get_domains_contacts', 'domain', {"domain_list" => domain_list})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Queries the domains expiring within the specified date range
      #
      # ==== Required
      #  * <tt>:start_date</tt> - beginning date of the expiration range
      #  * <tt>:end_date</tt> - ending date of the expiration range
      def get_domains_by_expiredate(start_date, end_date)
        try_opensrs do
          cmd = Command.new('get_domains_by_expiredate', 'domain', {"exp_from" => start_date.to_s, "exp_to" => end_date.to_s})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Retrieves the domain notes that detail the history of the domain (renewals, transfers, etc.)
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get the notes for
      def get_notes_for_domain(domain)
        try_opensrs do
          cmd = Command.new('get_notes', 'domain', {"domain" => domain, "type" => "domain"})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Retrieves the domain notes based on an order
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get the notes for
      #  * <tt>:order_id</tt> - ID of the order
      def get_notes_for_order(domain, order_id)
        try_opensrs do
          cmd = Command.new('get_notes', 'domain', {"domain" => domain, "order_id" => order_id, "type" => "order"})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Retrieves the domain notes based on a transfer ID
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get the notes for
      #  * <tt>:transfer_id</tt> - ID of the transfer
      def get_notes_for_transfer(domain, transfer_id)
        try_opensrs do
          cmd = Command.new('get_notes', 'domain', {"domain" => domain, "transfer_id" => transfer_id, "type" => "transfer"})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Queries all information related to an order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the order
      def get_order_info(order_id)
        try_opensrs do
          cmd = Command.new('get_order_info', 'domain', {"order_id" => order_id})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Retrieves information about orders placed for a specific domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to get orders for
      def get_orders_by_domain(domain)
        try_opensrs do
          cmd = Command.new('get_orders_by_domain', 'domain', {"domain" => domain})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Queries the price of a domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to query the price of
      def get_price(domain)
        try_opensrs do
          cmd = Command.new('get_price', 'domain', {"domain" => domain})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Queries the properties of the specified Trust Service product
      #
      # ==== Required
      #  * <tt>:product_id</tt> - ID of the product
      def get_product_info(product_id)
        try_opensrs do
          cmd = Command.new('get_product_info', 'trust_service', {"product_id" => product_id})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Determines the availability of a domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain to check availability of
      def lookup_domain(domain)
        try_opensrs do
          cmd = Command.new('lookup', 'domain', {"domain" => domain})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Provides suggestions for a domain name for the specified TLDs
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain
      #  * <tt>:tlds</tt> - list of TLDs to make suggestions with
      def name_suggest(domain, tlds)
        try_opensrs do
          tlds_indexed = {}
          tlds.each_with_index do |tld, index|
            tlds_indexed[index] = tld
          end

          cmd = Command.new('name_suggest', 'domain', {"searchstring" => domain, "tlds" => tlds_indexed})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end
    end
  end
end
