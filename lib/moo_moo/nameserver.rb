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
  end
end