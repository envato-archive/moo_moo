require 'moo_moo/exceptions'

module MooMoo
  autoload :Version, 'moo_moo/version'
  autoload :Config,  'moo_moo/config'
  autoload :OpenSRS, 'moo_moo/opensrs'
  autoload :Base, 'moo_moo/base'
  autoload :Lookup, 'moo_moo/lookup'
  autoload :Nameserver, 'moo_moo/nameserver'
  autoload :Provisioning, 'moo_moo/provisioning'
  autoload :Transfer, 'moo_moo/transfer'
  autoload :Cookie, 'moo_moo/cookie'

  class << self
    attr_accessor :config
  end

  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end
