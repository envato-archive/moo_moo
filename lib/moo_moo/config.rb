module MooMoo
  class Config
    attr_accessor :host
    attr_accessor :key
    attr_accessor :user
    attr_accessor :pass
    attr_accessor :port

    def initialize
      @host = 'horizion.opensrs.net'
    end
  end
end
