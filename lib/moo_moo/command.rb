require 'rexml/document'
require 'digest/md5'
require 'net/http'

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
      body    = build_command.to_s
      headers = {
        'Content-Type' => 'text/xml',
        'X-Username' => user,
        'X-Signature' => signature(body, key),
        'Content-Length' => body.size.to_s
      }

      http = Net::HTTP.new(URI.encode(host), port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      #http.ca_file = File.join(File.dirname(__FILE__), "../..", "cacert.pem")
      res = http.post(URI.encode("/"), body, headers)

      # Checks for invalid http status
      unless (200..299).include?(res.code.to_i)
        raise OpenSRSException, "Bad HTTP Status: #{res.code}"
      end

      @returned_parameters = parse_response(res.body)
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

    # Parses an XML response from the OpenSRS registry and generates a
    # hash containing all of the data. Elements with child elements
    # are converted into hashes themselves, with the :element_text entry
    # containing any raw text
    #
    # ==== Required
    #  * <tt>data</tt> - data of the response
    def parse_response(data)
      doc = REXML::Document.new(data)

      elements = doc.elements["/OPS_envelope/body/data_block/dt_assoc"].select { |item|
        item.is_a? REXML::Element
      }

      build_xml_hash(elements)
    end

    # Builds a hash from a collection of XML elements
    #
    # ==== Required
    #  * <tt>elements</tt> - collection of elemenents
    def build_xml_hash(elements)
      data_hash = {}

      elements.each do |elem|
        key = elem.attributes['key']

        if elem.elements.size > 0
          if key.nil?
            data_hash.merge!(build_xml_hash(elem.elements))
          else
            data_hash[key] = build_xml_hash(elem.elements)
          end
        else
          data_hash[key] = elem.text unless key.nil?
        end
      end

      data_hash
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