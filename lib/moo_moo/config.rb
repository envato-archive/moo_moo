require 'yaml'

module MooMoo
  class Config
    attr_accessor :host
    attr_accessor :key
    attr_accessor :username
    attr_accessor :password
    attr_accessor :port

    def initialize
      @host     = default_option("host") || 'horizon.opensrs.net'
      @key      = default_option("key")
      @username = default_option("username")
      @password = default_option("password")
      @port     = default_option("port")
    end

    private

    def options_file_name
      ".moomoo.yml"
    end

    # Retrieves default options coming from a configuration file, if any.
    def default_option(key)
      @yaml ||= begin
        if File.exists?(options_file_name)
          YAML.load(File.open(options_file_name))
        else
          {}
        end
      end

      @yaml[key.to_s]
    end
  end
end
