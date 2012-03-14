require 'rexml/document'
require 'digest/md5'
require 'faraday'

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
      conn = Faraday.new(:url => "https://#{host}:#{port}", :ssl => {:verify => true}) do |c|
        c.response :parse_open_srs
        c.response :open_srs_errors
        c.adapter :net_http
      end
      
      body = build_command.to_s
      @returned_parameters = conn.post do |r|
        r.body = body
        r.headers = {
          'Content-Type' => 'text/xml',
          'X-Username' => user,
          'X-Signature' => signature(body, key),
          'Content-Length' => body.size.to_s
        }
      end.body
    end

    private

    # Adds XML child elements to the specified XML element for a given collection
    #
    # ==== Required
    #  * <tt>:elem</tt> - XML element to add the child nodes to
    #  * <tt>:coll</tt> - collection that will be added as XML child elements
    def build_child(elem, coll)
      if coll.is_a?(Hash)
        elem = elem.add_element("dt_assoc")
        coll.each do |key, val|
          child = elem.add_element('item', {'key' => key})
          build_child(child, val)
        end
      elsif coll.is_a?(Array)
        elem = elem.add_element("dt_array")
        coll.each_with_index do |val, key|
          child = elem.add_element('item', {'key' => key})
          build_child(child, val)
        end
      else
        elem.text = coll
      end
    end

    # Builds an XML string of the command which can be sent to OpenSRS
    def build_command
      xml = <<-XML
      <?xml version='1.0' encoding='UTF-8' standalone='no' ?>
      <!DOCTYPE OPS_envelope SYSTEM 'ops.dtd'>
      <OPS_envelope>
        <header>
          <version>0.9</version>
        </header>
        <body>
          <data_block>
            <dt_assoc>
              <item key="protocol">XCP</item>
              <item key="action">GET_BALANCE</item>
              <item key="object">BALANCE</item>
              <item key="registrant_ip"/>
            </dt_assoc>
          </data_block>
        </body>
      </OPS_envelope>
      XML

      doc = REXML::Document.new(xml)
      doc.root.elements["body/data_block/dt_assoc/item[@key='action']"].text = @action
      doc.root.elements["body/data_block/dt_assoc/item[@key='object']"].text = @object

      unless @cookie.nil?
        cookie_elem = doc.root.elements["body/data_block/dt_assoc"].add_element('item', {'key' => 'cookie'})
        cookie_elem.text = @cookie
      end

      unless @params.nil?
        elem = doc.root.elements["body/data_block/dt_assoc"].add_element('item', {'key' => 'attributes'})
        build_child(elem, @params)
      end

      doc
    end

    def signature(content, key)
      Digest::MD5.hexdigest(
        Digest::MD5.hexdigest(
          content + key
        ) + key
      )
    end
  end
end