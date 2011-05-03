module MooMoo
  module Utils
    def try_opensrs
      begin
        yield
      rescue OpenSRSException => x
        raise OpenSRSException, x.message
      end
    end
  end
end
