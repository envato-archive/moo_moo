module MooMoo
  class OpenSRS
    module TransferCommands
      # Cancels a transfer that is pending owner approval
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name that is being transferred
      #  * <tt>:reseller</tt> - username of the reseller
      def cancel_transfer(domain, reseller)
        try_opensrs do
          cmd = Command.new('cancel_transfer', 'transfer', {"domain" => domain, "reseller" => reseller})
          result = run_command(cmd)

          Response.new(result)
        end
      end

      # Cancels a transfer that is pending owner approval by order ID
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the order
      #  * <tt>:reseller</tt> - username of the reseller
      def cancel_transfer_for_order(order_id, reseller)
        try_opensrs do
          cmd = Command.new('cancel_transfer', 'transfer', {"order_id" => order_id, "reseller" => reseller})
          result = run_command(cmd)

          Response.new(result)
        end
      end

      # Checks to see if the given domain can be transferred
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to check
      def check_transfer(domain)
        try_opensrs do
          cmd = Command.new('check_transfer', 'domain', {"domain" => domain})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Lists all domains that have been transferred away
      #
      def get_transfers_away
        try_opensrs do
          cmd = Command.new('get_transfers_away', 'domain')
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Lists all domains that have been transferred in
      def get_transfers_in
        try_opensrs do
          cmd = Command.new('get_transfers_in', 'domain')
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Creates a new order with the same data as a cancelled order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the cancelled order
      #  * <tt>:reseller</tt> - username of the reseller
      def process_transfer(order_id, reseller)
        try_opensrs do
          cmd = Command.new('process_transfer', 'transfer', {"order_id" => order_id, "reseller" => reseller})
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Resends an e-mail to the admin contact for the transfer that is in 'pending owner approval' state
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name being transferred
      def send_password(domain)
        try_opensrs do
          cmd = Command.new('send_password', 'transfer', {"domain_name" => domain})
          result = run_command(cmd)

          Response.new(result)
        end
      end

      # Transfers a domain name from one reseller to another
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to transfer
      #  * <tt>:username</tt> - username of the registrant
      #  * <tt>:password</tt> - password of the registrant
      #  * <tt>:reseller</tt> - name of the gaining reseller
      def push_transfer(domain, username, password, reseller)
        try_opensrs do
          cmd = Command.new('rsp2rsp_push_transfer', nil, {"domain" => domain, "username" => username, "password" => password, "grsp" => reseller})
          result = run_command(cmd)

          Response.new(result)
        end
      end
    end
  end
end
