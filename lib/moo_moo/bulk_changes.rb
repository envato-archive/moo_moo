module MooMoo
  class BulkChanges < Base

    ##
    # Submits a request to transfer several domains at once. The list is grouped by the admin
    # contact email address and only one email message (containing a list of the domains) is
    # sent to each admin contact.
    register_service :bulk_transfer, :domain

    ##
    # Submits a request to change information associated with a large set of domains. Can also be
    # used to check the availability of a list of domains, renew multiple domains, or to push
    # multiple domains to another Reseller account.
    #
    # You can submit the following bulk change requests with this API call: check availability,
    # domain lock/unlock, renewals, nameserver modification, contact changes, enable/disable
    # Parked Pages, enable WHOIS Privacy, and push domains to another Reseller account.
    register_service :submit, :bulk_change

    ##
    # This command allows you to enable or disable WHOIS Privacy for multiple domains. WHOIS Privacy
    # can be enabled or disabled for .COM, .NET, .ORG, .INFO, .BIZ, .ME, .MOBI, .NAME, .CC, .CO,
    # and .TV TLDs.
    register_service :submit_bulk_change, :bulk_change
  end
end