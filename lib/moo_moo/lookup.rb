module MooMoo
  class Lookup < Base

    ##
    # Determines whether the domain belongs to the RSP who issued the command.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to check ownership of
    register_service :belongs_to_rsp, :domain

    ##
    # Queries the requester's account, and returns the total amount of money in the account and
    # the amount that is allocated to pending transactions.
    register_service :get_balance, :balance

    ##
    # Lists domains that have been deleted due to expiration or deleted by request (revoked).
    # This command applies to all domains in a Reseller's profile. Results include the domain,
    # status, and deleted date.
    register_service :get_deleted_domains, :domain

    ##
    # Queries various types of data regarding the user's domain. For example, the all_info type
    # allows you to retrieve all data for the domain linked to the current cookie. The list type
    # queries the list of domains associated with the user's profile. The list type can also be
    # used to return a list of domains that expire within a specified range. The nameservers type
    # returns the nameservers currently acting as DNS servers for the domain.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to query
    #  * <tt>:cookie</tt> - cookie for the domain
    #
    # ==== Optional
    #  * <tt>:type</tt> - type of query to perform
    register_service :get_domain, :domain, :get

    ##
    # Queries contact information for a list of domains.
    #
    # ==== Required
    #  * <tt>:domains</tt> - domains to get contact information for
    register_service :get_domains_contacts, :domain

    ##
    # Retrieves domains that expire within a specified date range.
    #
    # ==== Required
    #  * <tt>:start_date</tt> - beginning date of the expiration range
    #  * <tt>:end_date</tt> - ending date of the expiration range
    register_service :get_domains_by_expiredate, :domain

    ##
    # Retrieves the domain notes that detail the history of the domain, for example, renewals and
    # transfers.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to get the notes for
    register_service :get_notes, :domain

    ##
    # Queries all the information for an order, but does not return sensitive information such as
    # username, password, and Authcode.
    #
    # ==== Required
    #  * <tt>:order_id</tt> - ID of the order
    register_service :get_order_info, :domain

    ##
    # Retrieves information about orders placed for a specific domain.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to get orders for
    register_service :get_orders_by_domain, :domain

    ##
    # Queries the price of a domain, and can be used to determine the cost of a billable transaction
    # for any TLD. A returned price for a given domain does not guarantee the availability of the
    # domain, but indicates that the requested action is supported by the system and calculates the
    # cost to register the domain (if available).
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
    # Determines the availability of a specified domain name.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain to check availability of
    register_service :lookup_domain, :domain, :lookup

    ##
    # Checks whether a specified name, word, or phrase is available for registration in gTLDs and
    # ccTLDs, suggests other similar domain names for .COM, .NET, .ORG, .INFO, .BIZ, .US, and .MOBI
    # domains, and checks whether they are available. Reseller must be enabled for the specified TLDs.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain
    #  * <tt>:tlds</tt> - list of TLDs to make suggestions with
    register_service :name_suggest, :domain
  end
end