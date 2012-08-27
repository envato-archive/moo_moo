module MooMoo
  class Transfer < BaseCommand

    ##
    # Cancels transfers that are pending owner approval.
    #
    # http://www.opensrs.com/docs/apidomains/cancel_transfer.htm
    register_service :cancel_transfer, :transfer

    ##
    # Cancels a transfer that is pending owner approval by order ID
    #
    # Note: This method may be deprecated
    register_service :cancel_transfer_for_order, :transfer

    ##
    # Checks to see if the specified domain can be transferred in to OpenSRS, or transferred from one
    # OpenSRS Reseller to another. This call can also be used to check the status of the last transfer
    # request on a given domain name.
    #
    # http://www.opensrs.com/docs/apidomains/check_transfer.htm
    register_service :check_transfer, :domain

    ##
    # Lists domains that have been transferred away. This command applies to all domains in a
    # Reseller's profile.
    #
    # http://www.opensrs.com/docs/apidomains/get_transfers_away.htm
    register_service :get_transfers_away, :domain

    ##
    # Lists domains that have been transferred in. This command applies to all domains in a Reseller's
    # profile.
    #
    # http://www.opensrs.com/docs/apidomains/get_transfers_in.htm
    register_service :get_transfers_in, :domain

    ##
    # Creates a new order with the same data as a cancelled order; the existing cancelled order is
    # not modified. This command is only available for failed transfers with the status of 'cancelled'.
    #
    # http://www.opensrs.com/docs/apidomains/process_transfer.htm
    register_service :process_transfer, :transfer

    ##
    # Resends an email message for a transfer that is in 'pending owner approval' state, to the admin
    # contact listed for the domain at the time that the transfer request was submitted. If a transfer
    # is currently in progress, but in a different state, an error is returned.
    #
    # http://www.opensrs.com/docs/apidomains/send_password_transfer.htm
    register_service :send_password, :transfer

    ##
    # Transfer a domain from one Reseller to another Reseller. The domain is not renewed when it is
    # transferred and so no charges are incurred.
    #
    # http://www.opensrs.com/docs/apidomains/rsp2rsp_push_transfer.htm
    register_service :push_transfer, :domain, :rsp2rsp_push_transfer
  end
end