module Faraday
  class Response::MooMooLogger < Response::Middleware
    def call(env)
      debug("[MooMoo request] #{env.body}")
      super
    end

    def on_complete(env)
      debug("[MooMoo response] #{env.body}")
    end

    private

    def debug(msg)
      MooMoo.config.logger.debug(msg) if MooMoo.config.logger
    end
  end
end

Faraday::Response.register_middleware(:moo_moo_logger => :MooMooLogger)
