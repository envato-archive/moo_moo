module MooMoo
  class Base
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
      @key  = key  || MooMoo.config.key
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

    def try_opensrs
      begin
        yield
      rescue Exception => e
        exception = OpenSRSException.new(e.message)
        exception.set_backtrace(e.backtrace)
        raise exception
      end
    end
  end
end