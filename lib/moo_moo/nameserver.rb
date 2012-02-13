module MooMoo
  class Nameserver < Base

    ##
    # Creates a nameserver in the same domain space as the cookie's domain.
    #
    # ==== Required
    #  * <tt>:name</tt> - name of the nameserver
    #  * <tt>:ip</tt> - ip address for the nameserver
    #  * <tt>:domain</tt> - domain name to create it for
    #
    # ==== Optional
    #  * <tt>:cookie</tt> - cookie for domain
    register_service :create, :nameserver

    ##
    # Deletes a nameserver.
    #
    # ==== Required
    #  * <tt>:name</tt> - name of the nameserver
    #  * <tt>:ip</tt> - ip address for the nameserver
    #  * <tt>:domain</tt> - domain name to create it for
    #
    # ==== Optional
    #  * <tt>:cookie</tt> - cookie for domain
    register_service :delete, :nameserver

    ##
    # Queries nameservers that exist in the current user profile (current cookie). These nameservers
    # may or may not be currently assigned to a domain.
    #
    # ==== Required
    #  * <tt>:domain</tt> - domain profile to query
    register_service :get, :nameserver

    ##
    # Renames a nameserver.
    #
    # ==== Required
    #  * <tt>:name</tt> - current name of the nameserver
    #  * <tt>:ip</tt> - ip address of the name server
    #  * <tt>:new_name</tt> - new name for the nameserver
    #  * <tt>:domain</tt> - domain profile the nameserver was created for
    register_service :modify, :nameserver

    ##
    # Adds nameservers to a domain, or adds or removes nameservers for a domain that already has
    # nameservers assigned to it. This command does not create a nameserver; the nameserver must
    # already exist (see "create (nameserver)").
    #
    # This command is not supported for the following domains:.AT, .CH, .DK, .FR, .LI, and .MX.
    # Use the update_all_info command to change the nameservers for any of these domains.
    register_service :advanced_update, :domain, :advanced_update_nameservers

    ##
    # Adds a nameserver to one or all registries to which a Reseller has access. This command does
    # not create a nameserver; a nameserver must already be created..
    register_service :registry_add, :nameserver, :registry_add_ns

    ##
    # Verifies whether a nameserver exists at a particular registry.
    register_service :registry_check, :nameserver, :registry_check_nameserver
  end
end