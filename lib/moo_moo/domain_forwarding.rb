module MooMoo
  class DomainForwarding < Base

    ##
    # Create domain forwarding service that is used to redirect visitors from one web address to
    # another. Once you create domain forwarding, you need to use the set_domain_forwarding
    # command to configure the settings.
    register_service :create, :domain, :create_domain_forwarding

    ##
    # Delete the domain forwarding service for the specified domain.
    register_service :delete, :domain, :delete_domain_forwarding

    ##
    # Queries the domain forwarding settings for a specified domain.
    register_service :get, :domain, :get_domain_forwarding

    ##
    # Configures the domain forwarding settings for a domain.
    register_service :set, :domain, :set_domain_forwarding
  end
end