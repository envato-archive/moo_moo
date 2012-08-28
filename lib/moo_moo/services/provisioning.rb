module MooMoo
  class Provisioning < BaseCommand

    ##
    # Cancels a Trust Service order
    register_service :cancel_order, :trust_service

    ##
    # Cancels orders with a status of pending or declined.
    #
    # http://www.opensrs.com/docs/apidomains/cancel_pending_orders.htm
    register_service :cancel_pending_orders, :order

    ##
    # Changes information associated with a domain, such as contact info. The action request message
    # is different depending on the type of modification being made, and is shown separately for each
    # type.
    #
    # http://www.opensrs.com/docs/apidomains/modify_domain.htm
    register_service :modify, :domain

    ##
    # Processes or cancels pending orders; also applicable to any order that is declined. The order
    # is cancelled and a new order is created. Can also be used to process cancelled orders, provided
    # the cancelled order was a new order or a transfer.
    #
    # http://www.opensrs.com/docs/apidomains/process_pending.htm
    register_service :process_pending, :domain

    ##
    # Renews a domain and allows you to set the auto-renewal flag on a domain.
    #
    # http://www.opensrs.com/docs/apidomains/renew_domain.htm
    register_service :renew, :domain

    ##
    # Removes the domain at the registry. Use this command to request a refund for a domain purchase.
    # This call can refund/revoke only one domain at the time.
    #
    # http://www.opensrs.com/docs/apidomains/revoke_domain.htm
    register_service :revoke, :domain

    ##
    # Submits a domain-contact information update to the OpenSRS system. Each contact object is
    # submitted as a whole to OpenSRS, and changes are parsed against the existing information.
    #
    # http://www.opensrs.com/docs/apidomains/update_contacts.htm
    register_service :update_contacts, :domain

    ##
    # Submits a new domain registration or transfer order that obeys the Reseller's 'process
    # immediately' flag setting.
    #
    # http://www.opensrs.com/docs/apidomains/sw_register.htm
    # Note: Requirements vary depending on TLD
    register_service :sw_register, :domain

    ##
    # Submits a new registration request or transfer order
    register_service :register_trust_service, :trust_service

    ##
    # Updates contact information for a domain using modify.
    #
    # * <tt>:domain</tt> - the domain to update for. E.g.: "domain1.com"
    # * <tt>:attributes</tt> - a contact attributes hash like:
    #     {
    #       type:        "type", # admin, billing, etc
    #       first_name:  "first_name",
    #       last_name:   "last_name"
    #       ... other attributes ...
    #     }
    #
    # In case of errors, an errors array like this will be returned:
    #
    #     ["Error1", "Error2"]
    def update_contact(domain, contact_attributes)
      contact_set = {
        contact_attributes[:type] => contact_attributes
      }

      # Removes the type key from contact_attributes
      contact_set[contact_attributes[:type]].delete(:type)

      response = api_modify(params_with_domain(domain).merge({
        :attributes => {
          :affect_domains => "0",
          :data =>           "contact_info",
          :contact_set =>    contact_set
        }
      }))

      if successful?
        response
      else
        attributes["details"][domain]["response_text"].split("\n")
      end
    end

    private

    def params_with_domain(domain)
      { :domain => domain }
    end
  end
end