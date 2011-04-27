module MooMoo
  class OpenSRS
    class Response
      def initialize(success, hash = {})
        @success = success
        #@response_text = response_text
        @hash = hash
      end

      def success?
        @success
      end

      def response_text
        @response_text
      end

      def result
        @hash
      end
    end
  end
end
