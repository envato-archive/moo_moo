module MooMoo
  module Utils
    def try_opensrs
      begin
        yield
      rescue OpenSRSException => x
        # TODO: do we need any pre conditioning before passing the
        #       exception up the tree?
=begin
        DEBUG_LOGGER.log_info("OPENSRS BACKTRACE: #{x.message}\n\n#{x.backtrace.join("\n")}")
=end
        raise OpenSRSException, x.message
      end
    end
  end
end
