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
      xml = build_command(@action, @object, @params, @cookie)

      md5_signature = Digest::MD5.hexdigest(
        Digest::MD5.hexdigest(
          xml + key
        ) + key
      )

      headers = {
        'Content-Type' => 'text/xml',
        'X-Username' => user,
        'X-Signature' => md5_signature,
        'Content-Length' => xml.size.to_s
      }

      http = Net::HTTP.new(URI.encode(host), port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.post(URI.encode("/"), xml, headers)

      @returned_parameters = parse_response(res.body)
    end

    private

    # Adds XML child elements to the specified XML element for a given collection
    #
    # ==== Required
    #  * <tt>:elem</tt> - XML element to add the child nodes to
    #  * <tt>:coll</tt> - collection that will be added as XML child elements
    def xml_add_collection_as_child(elem, coll)
      # default collection type is array
      dt_type = 'dt_array'

      # if it's a hash, make sure the keys aren't numeric
      if coll.is_a?(Hash)
        begin
          Float(coll.keys.first)
        rescue
          # the keys weren't numeric, so it really is an association (hash)
          dt_type = 'dt_assoc'
        end
      end

      elem = elem.add_element(dt_type)
      coll = coll.first if coll.is_a? Array
                                                            
      coll.each do |key, value|
        child = elem.add_element('item', {'key' => key})
        if value.is_a?(Hash) || value.is_a?(Array)
          xml_add_collection_as_child(child, value)
        else
          child.text = value
        end
      end
    end
                                                              
    # Builds an XML string of the command which can be sent to OpenSRS
    #
    # ==== Required
    #  * <tt>:action</tt> - action of the command
    #  * <tt>:object</tt> - object the command operates on
    #
    # ==== Optional
    #  * <tt>:attributes</tt> - additional attributes for the command
    #  * <tt>:cookie</tt> - cookie for the domain if the command requires it
    def build_command(action, object, attributes = nil, cookie = nil)
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
      doc.root.elements["body/data_block/dt_assoc/item[@key='action']"].text = action
      doc.root.elements["body/data_block/dt_assoc/item[@key='object']"].text = object

      unless cookie.nil?
        cookie_elem = doc.root.elements["body/data_block/dt_assoc"].add_element('item', {'key' => 'cookie'})
        cookie_elem.text = cookie
      end

      unless attributes.nil?
        elem = doc.root.elements["body/data_block/dt_assoc"].add_element('item', {'key' => 'attributes'})
        elem = elem.add_element('dt_assoc')
        attributes.each_pair do |key, value|
          attrib_elem = elem.add_element('item', {'key' => key})
          if value.is_a?(Hash) || value.is_a?(Array)
            xml_add_collection_as_child(attrib_elem, value)
          else
            attrib_elem.text = (value.is_a?(String) ? value.dup : value)
          end
        end
      end

      doc.to_s
    end

    # Parses a text response into a collection of returned parameters
    #
    # ==== Required
    #  * <tt>data</tt> - data of the response
    # hash containing all of the data.
    def parse_text_response(data)
      lines = data.split(/[\r\n]+/).delete_if { |line| 
        (line =~ /^\s*\;/) || (line !~ /=/) || (line =~ /^\s*\-\s*Param\s+\@/) 
      }

      # generate the hash of returned parameters
      returned_parameters = {}
      lines.each { |line|
        key, value = line.split('=')
        key.downcase!
        returned_parameters.merge!({key => value})
      }
      returned_parameters
    end

    # Parses an XML response from the OpenSRS registry and generates a 
    # hash containing all of the data. Elements with child elements
    # are converted into hashes themselves, with the :element_text entry
    # containing any raw text
    #
    # ==== Required
    #  * <tt>data</tt> - data of the response
    def parse_xml_response(data)
      doc = REXML::Document.new(data)

      values = {}

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

    # Parses a response (text or XML) and returns a hash of the data
    # 
    # ==== Required
    #  * <tt>data</tt> - data of the response
    def parse_response(data)
      return parse_xml_response(data) if data =~ /^<\?xml/
      return parse_text_response(data)
    end

    # Extracts the child elements key/text values from the given element
    #
    # ==== Required
    #  * <tt>element</tt> - XML element with child elements
    #  * <tt>values</tt> - hash of values to populate
    def extract_values(element, values)
      element.elements.each do |item|
        values[item.attributes['key']] = item.text
      end
    end
  end
end
