module MooMoo
  require 'moo_moo/opensrs/args'

  autoload :Command, 'moo_moo/opensrs/command'
  autoload :OpenSRSException, 'moo_moo/opensrs/opensrsexception'
  autoload :Utils, 'moo_moo/opensrs/utils'
  autoload :LookupCommands, 'moo_moo/opensrs/lookup_commands'
  autoload :ProvisioningCommands, 'moo_moo/opensrs/provisioning_commands'
  autoload :TransferCommands, 'moo_moo/opensrs/transfer_commands'
  autoload :NameserverCommands, 'moo_moo/opensrs/nameserver_commands'
  autoload :CookieCommands, 'moo_moo/opensrs/cookie_commands'

  require 'moo_moo/opensrs/response'

  class OpenSRS
    include LookupCommands
    include ProvisioningCommands
    include TransferCommands
    include NameserverCommands
    include CookieCommands
    include Utils

    attr_reader :host, :key, :user, :pass, :port

    # Constructor
    #
    # === Required
    #  * <tt>:host</tt> - host of the OpenSRS server
    #  * <tt>:key</tt> - private key
    #  * <tt>:user</tt> - username of the reseller
    #  * <tt>:pass</tt> - password of the rseller
    #
    # === Optional
    #  * <tt>:port</tt> - port to connect on
    def initialize(host = nil, key = nil, user = nil, pass = nil, port = 55443)
      @host = host || MooMoo.config.host
      @key = key || MooMoo.config.key
      @user = user || MooMoo.config.user
      @pass = pass || MooMoo.config.pass
      @port = port || MooMoo.config.port
    end

    # Runs a command
    #
    # === Required
    #  * <tt>:command</tt> - command to run
    #  * <tt>:command</tt> - command to run
    #
    # === Optional
    #  * <tt>:params</tt> - parameters for the command
    #  * <tt>:cookie</tt> - cookie, if the command requires it
    def run_command(action, object, params = {}, cookie = nil)
      cmd = Command.new(action, object, params, cookie)

      try_opensrs do
        result = cmd.run(@host, @key, @user, @port)
        Response.new(result, params[:key])
      end
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
