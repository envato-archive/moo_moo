module MooMoo
  autoload :Config, 'moo_moo/config'

  class << self
    attr_accessor :config
  end

  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end
