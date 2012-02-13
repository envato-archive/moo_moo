module MooMoo
  class Provisioning < Base

    ##
    # Cancels a Trust Service order
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the order
    register_service :cancel_order, :trust_service

    ##
    # Cancels pending or declined orders
    #
    # ==== Required
    #  * <tt>:to_date</tt> - date before which to cancel orders
    register_service :cancel_pending_orders, :order

    ##
    # Changes information associated with a domain
    #
    # ==== Required
    #  * <tt>:type</tt> - type of data to modify
    #  * <tt>:params</tt> - new parameter values to set
    #
    # ==== Optional
    #  * <tt>:cookie</tt> - cookie for the domain
    register_service :modify, :domain

    ##
    # Processes or cancels a pending order
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the pending order to process
    register_service :process_pending, :domain

    ##
    # Renews a domain name
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to renew
    #  * <tt>:term</tt> - number of years to renew for
    #  * <tt>:current_expiration_year</tt> - current expiration year in YYYY format
    register_service :renew_domain, :domain, :renew

    ##
    # Removes the domain at the registry
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to remove
    #  * <tt>:reseller</tt> - username of the reseller
    register_service :revoke, :domain

    ##
    # Submits a domain contact information update
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain name to update the contacts of
    #  * <tt>:contact_set</tt> - contact set with updated values
    #  * <tt>:types</tt> - list of contact types that are to be updated
    register_service :update_contacts, :domain

    ##
    # Submits a new registration request or transfer order
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
  end
end