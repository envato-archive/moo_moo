module MooMoo
  class DnsZone < Base

    ##
    # Creates a custom DNS zone for managed DNS service.
    #
    # http://www.opensrs.com/docs/apidomains/create_dns_zone_request.htm
    register_service :create_dns_zone, :domain

    ##
    # Deletes the DNS zones for the specified domain.
    #
    # http://www.opensrs.com/docs/apidomains/delete_dns_zone_request.htm
    register_service :delete_dns_zone, :domain

    ##
    # Changes the nameservers on your domain to use the 
    # nameservers for managed DNS service.
    #
    # http://www.opensrs.com/docs/apidomains/Request_parameters_for_force_dns_nameservers.htm
    register_service :force_dns_nameservers, :domain

    ##
    # View the DNS records for a specified domain.
    #
    # http://www.opensrs.com/docs/apidomains/get_dns_zone_request.htm
    register_service :get_dns_zone, :domain

    ##
    # Sets the DNS zone to the values in the specified template.
    # If a template is not specified in the command, the records 
    # are set to what was in the template that was used to enable 
    # the DNS service.
    #
    # http://www.opensrs.com/docs/apidomains/reset_dns_zone_request.htm
    register_service :reset_dns_zone, :domain

    ##
    # Set the records for a domain's DNS zone.
    #
    # http://www.opensrs.com/docs/apidomains/set_dns_zone_request.htm
    register_service :set_dns_zone, :domain

  end
end