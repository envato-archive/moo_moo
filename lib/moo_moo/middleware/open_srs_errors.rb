module MooMoo
  class OpenSRSErrors < Faraday::Response::Middleware

    def on_complete(env)
      # Checks for invalid http status
      unless (200..299).include?(env[:status])
        raise OpenSRSException, "Bad HTTP Status: #{env[:status]}"
      end
    end

  end
end