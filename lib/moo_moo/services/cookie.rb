module MooMoo
  class Cookie < Base

    ##
    # Creates a cookie for use in commands where a cookie is required to access OpenSRS.
    #
    # http://www.opensrs.com/docs/apidomains/set_cookie.htm
    register_service :set, :cookie

    ##
    # Deletes a cookie.
    #
    # http://www.opensrs.com/docs/apidomains/delete_(cookie).htm
    register_service :delete, :cookie

    ##
    # Allows the client to change the domain associated with the current cookie.
    #
    # http://www.opensrs.com/docs/apidomains/update_(cookie).htm
    register_service :update, :cookie

    ##
    # Cleanly terminates the connection.
    #
    # http://www.opensrs.com/docs/apidomains/quit_session.htm
    register_service :quit_session, :session, :quit
  end
end