require 'faraday'

Faraday.register_middleware :request, :open_srs_xml_builder => MooMoo::OpenSRSXMLBuilder
Faraday.register_middleware :response, :open_srs_errors => MooMoo::OpenSRSErrors, :parse_open_srs => MooMoo::ParseOpenSRS

module MooMoo
  class Command
    # Constructor
    #
    # ==== Required
    #  * <tt>:action</tt> - action of the command
    #  * <tt>:object</tt> - object the command operates on
    #  * <tt>:params</tt> - additional parameters for the command
    #
    # ==== Optional
    #  * <tt>:cookie</tt> - a cookie for the domain if the command requires it
    def initialize(action, object, params = {}, cookie = nil)
      @action = action
      @object = object
      @params = params
      @cookie = cookie
    end

    # Runs the command against OpenSRS server
    #
    # ==== Required
    #  * <tt>:host</tt> - host of the OpenSRS server
    #  * <tt>:key</tt> - private key for the account
    #  * <tt>:user</tt> - username for the account
    #  * <tt>:port</tt> - port to connect to
    def run(host, key, user, port)
      @returned_parameters = Faraday.new(:url => "https://#{host}:#{port}", :ssl => {:verify => true}) do |c|
        c.request :open_srs_xml_builder, @action, @object, @cookie, @params, key, user
        c.response :parse_open_srs
        c.response :open_srs_errors
        c.adapter :net_http
      end.post.body
    end

  end
end