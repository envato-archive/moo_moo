require 'moo_moo/exceptions'

module MooMoo
  autoload :Version, 'moo_moo/version'
  autoload :Config,  'moo_moo/config'
  autoload :OpenSRS, 'moo_moo/opensrs'
  autoload :Lookup, 'moo_moo/lookup'
  autoload :Nameserver, 'moo_moo/nameserver'
  autoload :Provisioning, 'moo_moo/provisioning'

  class << self
    attr_accessor :config
  end

  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end
