module MooMoo
  class OpenSRS
    class Response
      # Constructor
      #
      # ==== Required
      #  * <tt>:hash</tt> - hash of the response
      #
      # ==== Optional
      #  * <tt>:key</tt> - primary key to use when indexing the hash
      def initialize(hash, key = nil)
        @hash = hash
        @key = key
      end

      # Returns whether or not the command executed was successful
      #
      def success?
        @hash['is_success'].nil? ? true : @hash['is_success'].to_i == 1
      end

      # Returns the error message if one is present
      #
      def error_msg
        @hash['response_text']
      end

      # Returns the response code if one is present
      #
      def error_code
        @hash['response_code'].to_i
      end

      # Returns the result hash
      #
      def result
        @key.nil? ? @hash : @hash[@key]
      end
    end
  end
end
