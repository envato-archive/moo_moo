require 'yaml'

module MooMoo
  class Lookup < BaseCommand
    TLDS_FILE = File.expand_path("../../../../config/tlds.yml", __FILE__)

    ##
    # Determines whether the domain belongs to the RSP who issued the command.
    #
    # http://www.opensrs.com/docs/apidomains/belongs_to_rsp.htm
    register_service :belongs_to_rsp, :domain

    ##
    # Queries the requester's account, and returns the total amount of money in the account and
    # the amount that is allocated to pending transactions.
    #
    # http://www.opensrs.com/docs/apidomains/get_balance.htm
    register_service :get_balance, :balance

    ##
    # Lists domains that have been deleted due to expiration or deleted by request (revoked).
    # This command applies to all domains in a Reseller's profile. Results include the domain,
    # status, and deleted date.
    #
    # http://www.opensrs.com/docs/apidomains/get_deleted_domains.htm
    register_service :get_deleted_domains, :domain

    ##
    # Queries various types of data regarding the user's domain. For example, the all_info type
    # allows you to retrieve all data for the domain linked to the current cookie. The list type
    # queries the list of domains associated with the user's profile. The list type can also be
    # used to return a list of domains that expire within a specified range. The nameservers type
    # returns the nameservers currently acting as DNS servers for the domain.
    #
    # http://www.opensrs.com/docs/apidomains/get_domain.htm
    register_service :get, :domain

    # Queries contact information for a list of domains.
    #
    # http://www.opensrs.com/docs/apidomains/get_domains_contacts.htm
    register_service :get_domains_contacts, :domain

    ##
    # Retrieves domains that expire within a specified date range.
    #
    # http://www.opensrs.com/docs/apidomains/get_domains_by_expiredate.htm
    register_service :get_domains_by_expiredate, :domain

    ##
    # Retrieves the domain notes that detail the history of the domain, for example, renewals and
    # transfers.
    #
    # http://www.opensrs.com/docs/apidomains/get_notes.htm
    register_service :get_notes, :domain

    ##
    # Queries all the information for an order, but does not return sensitive information such as
    # username, password, and Authcode.
    #
    # http://www.opensrs.com/docs/apidomains/get_order_info.htm
    register_service :get_order_info, :domain

    ##
    # Retrieves information about orders placed for a specific domain.
    #
    # http://www.opensrs.com/docs/apidomains/get_orders_by_domain.htm
    register_service :get_orders_by_domain, :domain

    ##
    # Queries the price of a domain, and can be used to determine the cost of a billable transaction
    # for any TLD. A returned price for a given domain does not guarantee the availability of the
    # domain, but indicates that the requested action is supported by the system and calculates the
    # cost to register the domain (if available).
    #
    # http://www.opensrs.com/docs/apidomains/get_price.htm
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
    # http://www.opensrs.com/docs/apidomains/lookup_domain.htm
    register_service :lookup, :domain

    ##
    # Checks whether a specified name, word, or phrase is available for registration in gTLDs and
    # ccTLDs, suggests other similar domain names for .COM, .NET, .ORG, .INFO, .BIZ, .US, and .MOBI
    # domains, and checks whether they are available. Reseller must be enabled for the specified TLDs.
    #
    # http://www.opensrs.com/docs/apidomains/name_suggest_domain.htm
    register_service :name_suggest, :domain

    ##
    # Queries contact information for a domain using get_domains_contacts.
    #
    # * <tt>:domain</tt> - the domain to query for. E.g.: "domain1.com"
    #
    # Returns an array like:
    #     [
    #       {
    #         :type =>       "type", # admin, billing, etc
    #         :first_name => "first_name",
    #         :last_name =>  "last_name"
    #         ... other attributes ...
    #       }
    #     ]
    def domain_contacts(domain)
      api_get_domains_contacts({ :attributes => { :domain_list => [domain] }})

      attributes[domain]["contact_set"].map do |(type, attributes)|
         {
          :type =>       type,
          :first_name => attributes["first_name"],
          :last_name =>  attributes["last_name"],
          :org_name =>   attributes["org_name"],
          :address1 =>   attributes["address1"],
          :address2 =>   attributes["address2"],
          :address3 =>   attributes["address3"],
          :city =>       attributes["city"],
          :state =>      attributes["state"],
          :country =>    attributes["country"],
          :postal_code =>attributes["postal_code"],
          :phone =>      attributes["phone"],
          :fax =>        attributes["fax"],
          :email =>      attributes["email"]
        }
      end
    end

    # Public: Lists top level domain OpenSRS supports. At this point, OpenSRS
    # does not have an api call to do that, so we keep our own list of supported
    # top level domains.
    def tlds
      @tlds ||= YAML.load_file(TLDS_FILE)
    end
  end
end