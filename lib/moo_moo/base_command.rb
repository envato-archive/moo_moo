module MooMoo
  # Defines the basic command structure.
  #
  # For OpenSRS api methods, create them like this, using the proper api action
  # name and object:
  #
  #     register_service :action_one, :object_one
  #
  # If you need customized responses, create a custom method:
  #
  #     def custom_action(parameter)
  #       api_action_one(... custom parameter ...)
  #       ... custom response processing ...
  #     end
  class BaseCommand
    attr_reader :host, :key, :username, :port, :response

    # Register an api service for the current class.
    #
    #     register_service :action_one, :object_one
    #
    # A method called "api_action_one" will then be created.
    #
    # === Parameters
    #
    # * <tt>action_name</tt> - the api action to be called
    # * <tt>object</tt> - the object
    #
    # === Optional
    # * <tt>options</tt> - the api paramenters. An object parameter can be
    # provided in order to override the default api object.
    def self.register_service(action_name, object, options={})
      define_method("api_#{action_name}") do |*args|
        params = args.first || {}
        object = params.delete(:object) if params[:object]
        perform(action_name, object, params)
      end
    end

    # Constructor
    #
    # === Required
    #  * <tt>:host</tt> - host of the OpenSRS server
    #  * <tt>:key</tt> - private key
    #  * <tt>:username</tt> - username of the reseller
    #
    # === Optional
    #  * <tt>:port</tt> - port to connect on
    def initialize(params = {})
      @host     = params[:host]     || MooMoo.config.host     || raise(OpenSRSException, "Host is required")
      @key      = params[:key]      || MooMoo.config.key      || raise(OpenSRSException, "Key is required")
      @username = params[:username] || MooMoo.config.username || raise(OpenSRSException, "Username is required")
      @port     = params[:port]     || MooMoo.config.port     || 55443
    end

    # Returns whether or not the command executed was successful
    def successful?
      response.body['is_success'].to_i == 1
    end

    # Returns the response message if one is present
    def message
      response.body['response_text']
    end

    # Returns the response attributes.
    def attributes
      response.body['attributes']
    end

    private

    # Runs a command
    #
    # === Required
    #  * <tt>:command</tt> - command to run
    #  * <tt>:command</tt> - command to run
    #
    # === Optional
    #  * <tt>:params</tt> - parameters for the command.
    def perform(action, object, params = {})
      (@response = faraday_request(action, object, params)) && attributes
    end

    # Performs the Faraday request.
    def faraday_request(action, object, params)
      Faraday.new(:url => "https://#{host}:#{port}", :ssl => {:verify => true}) do |c|
        c.request  :open_srs_xml_builder, action, object, params, key, username
        c.response :parse_open_srs
        c.response :open_srs_errors
        c.response :moo_moo_logger
        c.adapter  :net_http
      end.post
    end

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
