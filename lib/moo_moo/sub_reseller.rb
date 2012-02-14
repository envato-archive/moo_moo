module MooMoo
  class SubReseller < Base

    ##
    # Creates a new Sub-Reseller account.
    register_service :create, :subreseller

    ##
    # Modify a Sub-Reseller account.
    register_service :modify, :subreseller

    ##
    # Returns information about a Sub-Reseller account.
    register_service :get, :subreseller

    ##
    # Transfers funds from the Reseller account into a Sub-Reseller account.
    register_service :pay, :subreseller
  end
end