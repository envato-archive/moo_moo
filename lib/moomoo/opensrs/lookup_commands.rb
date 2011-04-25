module MooMoo
  class OpenSRS
    module LookupCommands
      def belongs_to_rsp?(domain)
        try_opensrs do
          cmd = Command.new('belongs_to_rsp', 'domain', {"domain" => domain})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_balance
        try_opensrs do
          cmd = Command.new('get_balance', 'balance')
          result = run_command(cmd)

          {'balance' => result['attributes']['balance'].to_f,
           'hold_balance' => result['attributes']['hold_balance'].to_f}
        end
      end

      def get_deleted_domains
        try_opensrs do
          cmd = Command.new('get_deleted_domains', 'domain')
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_domain(domain, cookie, type = "all_info")
        try_opensrs do
          cmd = Command.new('get', 'domain', {"type" => "all_info"}, cookie)
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_domains_contacts(*domains)
        try_opensrs do
          domain_list = {}
          domains.each_with_index do |domain, index|
            domain_list[index] = domain
          end

          cmd = Command.new('get_domains_contacts', 'domain', {"domain_list" => domain_list})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_domains_by_expiredate(start_date, end_date)
        try_opensrs do
          cmd = Command.new('get_domains_by_expiredate', 'domain', {"exp_from" => start_date.to_s, "exp_to" => end_date.to_s})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_notes_for_domain(domain)
        try_opensrs do
          cmd = Command.new('get_notes', 'domain', {"domain" => domain, "type" => "domain"})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_notes_for_order(domain, order_id)
        try_opensrs do
          cmd = Command.new('get_notes', 'domain', {"domain" => domain, "order_id" => order_id, "type" => "order"})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_notes_for_transfer(domain, transfer_id)
        try_opensrs do
          cmd = Command.new('get_notes', 'domain', {"domain" => domain, "transfer_id" => transfer_id, "type" => "transfer"})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_order_info(order_id)
        try_opensrs do
          cmd = Command.new('get_order_info', 'domain', {"order_id" => order_id})
          result = run_command(cmd)

          result['attributes']['field_hash']
        end
      end

      def get_orders_by_domain(domain)
        try_opensrs do
          cmd = Command.new('get_orders_by_domain', 'domain', {"domain" => domain})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def get_price(domain)
        try_opensrs do
          cmd = Command.new('get_price', 'domain', {"domain" => domain})
          result = run_command(cmd)

          result['attributes']['price'].to_f
        end
      end

      def get_product_info(product_id)
        try_opensrs do
          cmd = Command.new('get_product_info', 'trust_service', {"product_id" => product_id})
          result = run_command(cmd)
        end
      end

      def lookup_domain(domain)
        try_opensrs do
          cmd = Command.new('lookup', 'domain', {"domain" => domain})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def name_suggest(domain, tlds)
        try_opensrs do
          tlds_indexed = {}
          tlds.each_with_index do |tld, index|
            tlds_indexed[index] = tld
          end

          cmd = Command.new('name_suggest', 'domain', {"searchstring" => domain, "tlds" => tlds_indexed})
          result = run_command(cmd)

          result['attributes']
        end
      end
    end
  end
end
