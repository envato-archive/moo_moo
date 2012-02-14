module MooMoo
  class Base
    attr_reader :host, :key, :user, :pass, :port

    # Register an api service for the current class.
    #
    #     register_service :action_one, :object_one
    #
    # That will generate the following method for this class:
    #
    #    def action_one(params)
    #      run_command :action_one, :object_one, params, cookie
    #    end
    #
    # === Parameters
    #
    # * <tt>method_name</tt> - the method name
    # * <tt>object</tt> - the object
    # * <tt>action_name</tt> - the api action to be called; by default it is the same as method_name
    def self.register_service(method_name, object, action_name = method_name, &block)
      define_method(method_name) do |*args|
        params = args.first || {}

        cookie = params.delete :cookie
        instance_exec(params, &block) if block
        run_command action_name, object, params, cookie
      end
    end

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
      @host = host || MooMoo.config.host || raise(ArgumentError, "Host is required")
      @key  = key  || MooMoo.config.key  || raise(ArgumentError, "Key is required")
      @user = user || MooMoo.config.user || raise(ArgumentError, "User is required")
      @pass = pass || MooMoo.config.pass || raise(ArgumentError, "Password is required")
      @port = port || MooMoo.config.port || raise(ArgumentError, "Port is required")
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

      begin
        result = cmd.run(@host, @key, @user, @port)
        Response.new(result)
      rescue Timeout::Error, Errno::ETIMEDOUT, Errno::EINVAL, Errno::ECONNRESET,
             Errno::ECONNREFUSED, EOFError, Net::HTTPBadResponse,
             Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        raise OpenSRSException.new(e)
      end
    end
  end
end