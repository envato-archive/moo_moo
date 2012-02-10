module MooMoo
  class Lookup < Base

    ##
    # Determines whether a domain belongs to the reseller
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to check ownership of
    register_service :belongs_to_rsp, :domain

    ##
    # Returns the balance of the reseller's account
    #
    register_service :get_balance, :balance

    ##
    # Lists domains that have been deleted due to expiration or request
    #
    register_service :get_deleted_domains, :domain

    ##
    # Queries various types of data associated with a domain
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to query
    #  * <tt>:cookie</tt> - cookie for the domain
    #
    # ==== Optional
    #  * <tt>:type</tt> - type of query to perform
    register_service :get_domain, :domain, :get

    ##
    # Queries contact information for a list of domains
    #
    # ==== Required
    #  * <tt>:domains</tt> - domains to get contact information for
    register_service :get_domains_contacts, :domain do |params|
      domain_list = {}
      params[:domain_list].each_with_index do |domain, index|
        domain_list[index] = domain
      end

      params[:domain_list] = domain_list
    end

    ##
    # Queries the domains expiring within the specified date range
    #
    # ==== Required
    #  * <tt>:start_date</tt> - beginning date of the expiration range
    #  * <tt>:end_date</tt> - ending date of the expiration range
    register_service :get_domains_by_expiredate, :domain

    ##
    # Retrieves the domain notes that detail the history of the domain (renewals, transfers, etc.)
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to get the notes for
    register_service :get_notes, :domain

    ##
    # Queries all information related to an order
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the order
    register_service :get_order_info, :domain

    ##
    # Retrieves information about orders placed for a specific domain
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to get orders for
    register_service :get_orders_by_domain, :domain

    ##
    # Queries the price of a domain
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to query the price of
    register_service :get_price, :domain

    ##
    # Queries the properties of the specified Trust Service product
    #
    # ==== Required
    #  * <tt>:product_id</tt> - ID of the product
    register_service :get_product_info, :trust_service

    ##
    # Determines the availability of a domain
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to check availability of
    register_service :lookup_domain, :domain, :lookup

    ##
    # Provides suggestions for a domain name for the specified TLDs
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain
    #  * <tt>:tlds</tt> - list of TLDs to make suggestions with
    register_service :name_suggest, :domain do |params|
      tlds_indexed = {}
      params[:tlds].each_with_index do |tld, index|
        tlds_indexed[index] = tld
      end

      params[:tlds] = tlds_indexed
    end
  end
end