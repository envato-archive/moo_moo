module MooMoo
  class Nameserver < BaseCommand

    # Adds nameservers to a domain, or adds or removes nameservers for a domain that already has nameservers assigned to it.
    #
    # http://www.opensrs.com/docs/apidomains/advanced_update_nameservers.htm
    register_service :advanced_update_nameservers, :domain

    ##
    # Creates a nameserver in the same domain space as the cookie's domain.
    #
    # http://www.opensrs.com/docs/apidomains/create_nameserver.htm
    register_service :create, :nameserver

    ##
    # Deletes a nameserver.
    #
    # http://www.opensrs.com/docs/apidomains/Delete_Nameserver.htm
    register_service :delete, :nameserver

    ##
    # Queries nameservers that exist in the current user profile (current cookie). These nameservers
    # may or may not be currently assigned to a domain.
    #
    # http://www.opensrs.com/docs/apidomains/get_nameserver.htm
    register_service :get, :nameserver

    ##
    # Renames a nameserver.
    #
    # http://www.opensrs.com/docs/apidomains/modify_nameserver.htm
    register_service :modify, :nameserver
  end
end
