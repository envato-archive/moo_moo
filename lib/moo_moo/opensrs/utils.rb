module MooMoo
  module Utils
    def try_opensrs
      begin
        yield
      rescue Exception => e
        raise OpenSRSException, e.message
      end
    end
  end
end
