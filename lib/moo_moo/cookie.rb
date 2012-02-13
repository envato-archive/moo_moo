module MooMoo
  class Cookie < Base

    ##
    # Creates a cookie for use in commands where a cookie is required to access OpenSRS.
    #
    # ==== Required
    #  * <tt>:username</tt> - username of the registrant
    #  * <tt>:password</tt> - password of the registrant
    #  * <tt>:domain</tt> - domain to set the cookie for
    register_service :set, :cookie

    ##
    # Deletes a cookie.
    #
    # ==== Required
    #  * <tt>:cookie</tt> - cookie to delete
    register_service :delete, :cookie

    ##
    # Allows the client to change the domain associated with the current cookie.
    #
    # ==== Required
    #  * <tt>:old_domain</tt> - domain the cookie is currently set for
    #  * <tt>:new_domain</tt> - domain to set the cookie for
    #  * <tt>:cookie</tt> - cookie to update
    register_service :update, :cookie

    ##
    # Cleanly terminates the connection.
    register_service :quit_session, :session, :quit
  end
end