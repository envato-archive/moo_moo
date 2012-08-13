module MooMoo
  class ParseOpenSRS < Faraday::Response::Middleware

    def on_complete(env)
      env[:body] = parse_response(env[:body])
    end

    def response_values(env)
      {:status => env[:status], :headers => env[:response_headers], :body => env[:body]}
    end

  private

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

  end
end
