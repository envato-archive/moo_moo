module MooMoo
  class PersonalNames < Base

    ##
    # Submits a new registration order for an available Personal Names domain.
    register_service :register, :surname, :su_register

    ##
    # Queries the properties of the domain.
    register_service :query, :surname

    ##
    # Changes properties of the domain. You can use this command to change the DNS records, enable
    # or disable email forwarding, or to change the service type, for example, to switch from
    # Webmail (no IMAP/POP/SMTP) to a regular mailbox.
    register_service :update, :surname

    ##
    # Deletes the Personal Names domain. This call can delete only one domain at a time.
    register_service :delete, :surname
  end
end