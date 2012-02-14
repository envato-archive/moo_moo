module MooMoo
  class DnsZones < Base

    ##
    # Enables the DNS service for a domain. If you have created a DNS template, you can specify the
    # template in the command to assign initial DNS records. The template is then associated with
    # the domain, so if you later issue the reset_dns_zone command, the records are set back to
    # what is defined in the template.
    register_service :create, :domain, :create_dns_zone

    ##
    # Deletes the DNS zones defined for the specified domain.
    register_service :delete, :domain, :delete_dns_zone

    ##
    # View the DNS records for a specified domain.
    register_service :get, :domain, :get_dns_zone

    ##
    # Sets the DNS zone to the values in the specified template. If a template is not specified in
    # the command, the records are set to what was in the template that was used to enable the DNS
    # service.
    register_service :reset, :domain, :reset_dns_zone

    ##
    # Set the records for a domain's DNS zone.
    register_service :set, :domain, :set_dns_zone

    ##
    # Changes the nameservers on your domain to use the DNS nameservers: ns1.systemdns.com,
    # ns2.systemdns.com, and ns2.systemdns.com.
    register_service :force_dns_nameservers, :domain
  end
end