module MooMoo
  # Based on opensrs_xmlapi.pdf page 25.
  class Response
    attr_reader :hash

    # Constructor
    #
    # ==== Required
    #  * <tt>:hash</tt> - response hash
    def initialize(hash)
      @hash = hash
    end

    # Returns whether or not the command executed was successful
    def success?
      @hash['is_success'] == '1'
    end

    # Returns the response code if one is present
    def code
      @hash['response_code'].to_i
    end

    # Returns the response message if one is present
    def text
      @hash['response_text']
    end

    # Returns the response attributes.
    def attributes
      @hash['attributes']
    end
  end
end