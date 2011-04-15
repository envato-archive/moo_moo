module MooMoo
  class OpenSRS
    module NameserverCommands
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

      def send_password(domain)
        try_opensrs do
          cmd = Command.new('send_password', 'transfer', {"domain_name" => domain})
          result = run_command(cmd)

          result['is_success'].to_i == 1
        end
      end

    end
  end
end
