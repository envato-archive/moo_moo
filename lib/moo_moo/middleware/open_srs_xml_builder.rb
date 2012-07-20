module MooMoo
  class OpenSRSXMLBuilder < Faraday::Middleware
    dependency 'rexml/document'
    dependency 'digest/md5'

    def initialize(app, *args)
      @action = args[0]
      @object = args[1]
      @cookie = args[2]
      @params = args[3]
      @key    = args[4]
      @user   = args[5]
      super(app)
    end

    def call(env)
      env[:body] = build_command.to_s
      env[:request_headers] = {
        'Content-Type' => 'text/xml',
        'X-Username' => @user,
        'X-Signature' => signature(env[:body]),
        'Content-Length' => env[:body].size.to_s
        }.merge(env[:request_headers])
      @app.call(env)
    end

  private

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
        if @params[:domain]
          domain = doc.root.elements["body/data_block/dt_assoc"].add_element('item', {'key' => 'domain'})
          domain.text = @params.delete(:domain)
        end

        elem = doc.root.elements["body/data_block/dt_assoc"].add_element('item', {'key' => 'attributes'})
        build_child(elem, @params)
      end

      doc
    end

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


    def signature(content)
      Digest::MD5.hexdigest(
        Digest::MD5.hexdigest(
          content + @key
        ) + @key
      )
    end

  end
end