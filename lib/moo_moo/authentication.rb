module MooMoo
  class Authentication < Base

    ##
    # Changes the username and password of the profile that owns the cookie's domain.
    register_service :change, :ownership

    ##
    # Changes the password of the profile associated with the cookie.
    register_service :change_password, :password

    ##
    # Sends the Authcode for an EPP domain to the admin contact. If the domain for which the request
    # is made does not use the EPP protocol, an error is returned.
    register_service :send_authcode, :domain

    ##
    # Sends an email containing the domain password to the domain's admin contact.
    register_service :send_password, :domain
  end
end