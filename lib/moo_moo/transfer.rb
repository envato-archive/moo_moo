module MooMoo
  class Transfer < Base

    ##
    # Cancels a transfer that is pending owner approval
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name that is being transferred
    #  * <tt>:reseller</tt> - username of the reseller
    register_service :cancel_transfer, :transfer

    ##
    # Cancels a transfer that is pending owner approval by order ID
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the order
    #  * <tt>:reseller</tt> - username of the reseller
    register_service :cancel_transfer_for_order, :transfer

    ##
    # Checks to see if the given domain can be transferred
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to check
    register_service :check_transfer, :domain

    ##
    # Lists all domains that have been transferred away
    #
    register_service :get_transfers_away, :domain

    ##
    # Lists all domains that have been transferred in
    register_service :get_transfers_in, :domain

    ##
    # Creates a new order with the same data as a cancelled order
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the cancelled order
    #  * <tt>:reseller</tt> - username of the reseller
    register_service :process_transfer, :transfer

    ##
    # Resends an e-mail to the admin contact for the transfer that is in 'pending owner approval' state
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name being transferred
    register_service :send_password, :transfer

    ##
    # Transfers a domain name from one reseller to another
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to transfer
    #  * <tt>:username</tt> - username of the registrant
    #  * <tt>:password</tt> - password of the registrant
    #  * <tt>:reseller</tt> - name of the gaining reseller
    register_service :push_transfer, :domain, :rsp2rsp_push_transfer
  end
end