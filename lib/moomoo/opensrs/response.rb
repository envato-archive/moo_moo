module MooMoo
  class OpenSRS
    class Response
      def initialize(hash, key = nil)
        @hash = hash
        @key = key
      end

      def success?
        @hash['is_success'].nil? ? true : @hash['is_success'].to_i == 1
      end

      def error_msg
        @hash['response_text']
      end

      def error_code
        @hash['response_code'].to_i
      end

      def response_text
        @response_text
      end

      def result
        @key.nil? ? @hash : @hash[@key]
      end
    end
  end
end
