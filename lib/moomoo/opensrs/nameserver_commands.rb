module MooMoo
  class OpenSRS
    module NameserverCommands
      def create_nameserver(name, ip)
        try_opensrs do
          cmd = Command.new('create', 'nameserver', {"name" => name, "ipaddress" => ip})
          result = run_command(cmd)

        end
      end

      def delete_nameserver(name, ip)
        try_opensrs do
          cmd = Command.new('delete', 'nameserver', {"name" => name, "ipaddress" => ip})
          result = run_command(cmd)

        end
      end

      def get_nameserver
        try_opensrs do
          cmd = Command.new('get', 'nameserver', {"name" => "all"})
          result = run_command(cmd)

        end
      end

      def modify_nameserver(name, ip, new_name)
        try_opensrs do
          cmd = Command.new('modify', 'nameserver', {"name" => name, "ipaddress" => ip, "new_name" => new_name})
          result = run_command(cmd)

        end
      end

      def set_cookie(username, password, domain)
        try_opensrs do
          cmd = Command.new('set', 'cookie', {"reg_username" => username, "reg_password" => password, "domain" => domain})
          result = run_command(cmd)

          result['attributes']
        end
      end

      def cancel_transfer(domain, reseller)
        try_opensrs do
          cmd = Command.new('cancel_transfer', 'transfer', {"domain" => domain, "reseller" => reseller})
          result = run_command(cmd)

          result['is_success'].to_i == 1
        end
      end

      def cancel_transfer_for_order(order_id, reseller)
        try_opensrs do
          cmd = Command.new('cancel_transfer', 'transfer', {"order_id" => order_id, "reseller" => reseller})
          result = run_command(cmd)

          result['is_success'].to_i == 1
        end
      end

      def check_transfer(domain)
        try_opensrs do
          cmd = Command.new('check_transfer', 'domain', {"domain" => domain})
          result = run_command(cmd)
        end
      end

      def get_transfers_away
        try_opensrs do
          cmd = Command.new('get_transfers_away', 'domain')
          result = run_command(cmd)
        end
      end

      def get_transfers_in
        try_opensrs do
          cmd = Command.new('get_transfers_in', 'domain')
          result = run_command(cmd)
        end
      end

      def process_transfer(order_id, reseller)
        try_opensrs do
          cmd = Command.new('process_transfer', 'transfer', {"order_id" => order_id, "reseller" => reseller})
          result = run_command(cmd)

          result['attributes']['order_id'].to_i
        end
      end
    end
  end
end
