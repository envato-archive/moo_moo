module MooMoo
  class User < Base

    ##
    # Creates a subuser for a user's account. Only one subuser can exist per account.
    register_service :add, :subuser

    ##
    # Deletes a subuser.
    register_service :delete, :subuser

    ##
    # Queries a domain's sub-user data.
    register_service :get, :subuser

    ##
    # Retrieves a user's general information.
    register_service :modify, :subuser

    ##
    # Modifies a domain's sub-user data.
    register_service :get_info, :userinfo, :get
  end
end