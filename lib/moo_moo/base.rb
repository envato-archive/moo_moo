module MooMoo
  class Base
    attr_reader :host, :key, :username, :password, :port

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

        instance_exec(params, &block) if block
        run_command action_name, object, params
      end
    end

    # Constructor
    #
    # === Required
    #  * <tt>:host</tt> - host of the OpenSRS server
    #  * <tt>:key</tt> - private key
    #  * <tt>:username</tt> - username of the reseller
    #  * <tt>:password</tt> - password of the rseller
    #
    # === Optional
    #  * <tt>:port</tt> - port to connect on
    def initialize(params = {})
      @host     = params[:host]     || MooMoo.config.host     || raise(OpenSRSException, "Host is required")
      @key      = params[:key]      || MooMoo.config.key      || raise(OpenSRSException, "Key is required")
      @username = params[:username] || MooMoo.config.username || raise(OpenSRSException, "Username is required")
      @password = params[:password] || MooMoo.config.password || raise(OpenSRSException, "Password is required")
      @port     = params[:port]     || MooMoo.config.port     || 55443
    end

    # Runs a command
    #
    # === Required
    #  * <tt>:command</tt> - command to run
    #  * <tt>:command</tt> - command to run
    #
    # === Optional
    #  * <tt>:params</tt> - parameters for the command
    def run_command(action, object, params = {})
      Response.new Command.new(action, object, params).run(@host, @key, @username, @port)
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