module MooMoo
  class Transfer < Base

    ##
    # Cancels transfers that are pending owner approval.
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
    # Checks to see if the specified domain can be transferred in to OpenSRS, or transferred from one
    # OpenSRS Reseller to another. This call can also be used to check the status of the last transfer
    # request on a given domain name.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to check
    register_service :check_transfer, :domain

    ##
    # Lists domains that have been transferred away. This command applies to all domains in a
    # Reseller's profile.
    register_service :get_transfers_away, :domain

    ##
    # Lists domains that have been transferred in. This command applies to all domains in a Reseller's
    # profile.
    register_service :get_transfers_in, :domain

    ##
    # Creates a new order with the same data as a cancelled order; the existing cancelled order is
    # not modified. This command is only available for failed transfers with the status of 'cancelled'.
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the cancelled order
    #  * <tt>:reseller</tt> - username of the reseller
    register_service :process_transfer, :transfer

    ##
    # Resends an email message for a transfer that is in 'pending owner approval' state, to the admin
    # contact listed for the domain at the time that the transfer request was submitted. If a transfer
    # is currently in progress, but in a different state, an error is returned.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name being transferred
    register_service :send_password, :transfer

    ##
    # Transfer a domain from one Reseller to another Reseller. The domain is not renewed when it is
    # transferred and so no charges are incurred.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to transfer
    #  * <tt>:username</tt> - username of the registrant
    #  * <tt>:password</tt> - password of the registrant
    #  * <tt>:reseller</tt> - name of the gaining reseller
    register_service :push_transfer, :domain, :rsp2rsp_push_transfer

    ##
    # Transfers ownership of a .EU or .BE domain name from one registrant to another.
    register_service :trade_domain, :domain
  end
end