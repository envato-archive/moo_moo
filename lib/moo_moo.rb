module MooMoo
  autoload :Version, 'moo_moo/version'
  autoload :Config,  'moo_moo/config'
  autoload :OpenSRS, 'moo_moo/opensrs'

  class << self
    attr_accessor :config
  end

  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end
