require 'moomoo/opensrs/command'
require 'moomoo/opensrs/response'
require 'moomoo/opensrs/opensrsexception'
require 'moomoo/opensrs/utils'
require 'moomoo/opensrs/lookup_commands'
require 'moomoo/opensrs/provisioning_commands'
require 'moomoo/opensrs/transfer_commands'
require 'moomoo/opensrs/nameserver_commands'
require 'moomoo/opensrs/cookie_commands'

module MooMoo
  class OpenSRS
    include Utils

    include LookupCommands
    include ProvisioningCommands
    include TransferCommands
    include NameserverCommands
    include CookieCommands

    # Constructor
    #
    # === Required
    #  * <tt>:host</tt> - host of the OpenSRS server
    #  * <tt>:key</tt> - private key
    #  * <tt>:user</tt> - username of the reseller
    #  * <tt>:password</tt> - password of the rseller
    #
    # === Optional
    #  * <tt>:port</tt> - port to connect on
    def initialize(host, key, user, password, port = 55443)
      @host = host
      @key = key
      @user = user
      @password = password
      @port = port
    end

    # Runs a command
    #
    # === Required
    #  * <tt>:command</tt> - command to run
    def run_command(command)
      command.run(@host, @key, @user, @port)
    end

    private

    # Indexes an array by building a hash with numeric keys
    #
    # === Required
    #  * <tt>:arr</tt> - array to build an indexed hash of
    def index_array(arr)
      arr_indexed = {}

      arr.each_with_index do |item, index|
        arr_indexed[index] = item
      end

      arr_indexed
    end
  end
end
