module MooMoo
  module OpenSRS
    module TransferCommands
      # Cancels a transfer that is pending owner approval
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name that is being transferred
      #  * <tt>:reseller</tt> - username of the reseller
      def cancel_transfer(params)
        run_command :cancel_transfer, :transfer, params
      end

      # Cancels a transfer that is pending owner approval by order ID
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the order
      #  * <tt>:reseller</tt> - username of the reseller
      def cancel_transfer_for_order(params)
        run_command :cancel_transfer, :transfer, params
      end

      # Checks to see if the given domain can be transferred
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to check
      def check_transfer(domain)
        run_command :check_transfer, :domain, {
          :domain => domain,
          :key => 'attributes'
        }
      end

      # Lists all domains that have been transferred away
      #
      def get_transfers_away
        run_command :get_transfers_away, :domain, {
          :key => 'attributes'
        }
      end

      # Lists all domains that have been transferred in
      def get_transfers_in
        run_command :get_transfers_in, :domain, {
          :key => 'attributes'
        }
      end

      # Creates a new order with the same data as a cancelled order
      #
      # ==== Required
      #  * <tt>:order_id</tt> - ID of the cancelled order
      #  * <tt>:reseller</tt> - username of the reseller
      def process_transfer(params)
        params[:key] = 'attributes'

        run_command :process_transfer, :transfer, params
      end

      # Resends an e-mail to the admin contact for the transfer that is in 'pending owner approval' state
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name being transferred
      def send_password(domain)
        run_command :send_password, :transfer, {
          :domain_name => domain
        }
      end

      # Transfers a domain name from one reseller to another
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain name to transfer
      #  * <tt>:username</tt> - username of the registrant
      #  * <tt>:password</tt> - password of the registrant
      #  * <tt>:reseller</tt> - name of the gaining reseller
      def push_transfer(params)
        params[:grsp] = params.delete :reseller

        run_command :rsp2rsp_push_transfer, nil, params
      end
    end
  end
end
