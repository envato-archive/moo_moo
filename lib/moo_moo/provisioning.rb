module MooMoo
  class Provisioning < Base

    ##
    # Cancels a Trust Service order
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the order
    register_service :cancel_order, :trust_service

    ##
    # Cancels orders with a status of pending or declined.
    #
    # ==== Required
    #  * <tt>:to_date</tt> - date before which to cancel orders
    register_service :cancel_pending_orders, :order

    ##
    # Changes information associated with a domain, such as contact info. The action request message
    # is different depending on the type of modification being made, and is shown separately for each
    # type.
    #
    # ==== Required
    #  * <tt>:type</tt> - type of data to modify
    #  * <tt>:params</tt> - new parameter values to set
    #
    # ==== Optional
    #  * <tt>:cookie</tt> - cookie for the domain
    register_service :modify, :domain

    ##
    # Processes or cancels pending orders; also applicable to any order that is declined. The order
    # is cancelled and a new order is created. Can also be used to process cancelled orders, provided
    # the cancelled order was a new order or a transfer.
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the pending order to process
    register_service :process_pending, :domain

    ##
    # Renews a domain and allows you to set the auto-renewal flag on a domain.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to renew
    #  * <tt>:term</tt> - number of years to renew for
    #  * <tt>:current_expiration_year</tt> - current expiration year in YYYY format
    register_service :renew_domain, :domain, :renew

    ##
    # Removes the domain at the registry. Use this command to request a refund for a domain purchase.
    # This call can refund/revoke only one domain at the time.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to remove
    #  * <tt>:reseller</tt> - username of the reseller
    register_service :revoke, :domain

    ##
    # Submits a domain-contact information update to the OpenSRS system. Each contact object is
    # submitted as a whole to OpenSRS, and changes are parsed against the existing information.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to update the contacts of
    #  * <tt>:contact_set</tt> - contact set with updated values
    #  * <tt>:types</tt> - list of contact types that are to be updated
    register_service :update_contacts, :domain

    ##
    # Submits a new domain registration or transfer order that obeys the Reseller's 'process
    # immediately' flag setting.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to register
    #  * <tt>:contacts</tt> - contact set for the domain
    #  * <tt>:nameservers</tt> - array of nameservers
    #
    # ==== Optional
    #  * <tt>:term</tt> - number of years to register the domain for
    #  * <tt>:options</tt> - additional attributes to set
    register_service :register_domain, :domain, :sw_register

    ##
    # Submits a new registration request or transfer order
    #
    # ==== Required
    #  * <tt>:csr</tt> - certificate signing request
    #  * <tt>:contacts</tt> - contact set for the trust service
    #
    # ==== Optional
    #  * <tt>:attribs</tt> - additional attributes to set
    #  * <tt>:term</tt> - number of years to register the trust service for
    register_service :register_trust_service, :trust_service

    ##
    # Removes the domain at the registry. Use this command to request a refund for a domain purchase.
    # This call can refund/revoke only one domain at the time.
    register_service :revoke_domain, :domain, :revoke

    ##
    # Creates a new Reseller account.
    register_service :create_reseller, :reseller, :create

    ##
    # Queries the status of a queued request.
    register_service :query_queued_request, :trust_service

    ##
    # Redeems a .COM, .NET, .CA, .IT, or .NL domain that has expired but is within the redemption
    # grace period.
    register_service :redeem_domain, :domain, :redeem
  end
end