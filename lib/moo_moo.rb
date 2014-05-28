require 'moo_moo/exceptions'
require 'faraday'
require 'moo_moo/version'
require 'moo_moo/logger'
require 'moo_moo/config'
require 'moo_moo/base_command'
require 'moo_moo/middleware/open_srs_errors'
require 'moo_moo/middleware/parse_open_srs'
require 'moo_moo/middleware/open_srs_xml_builder'

module MooMoo
  class << self
    attr_accessor :config
  end

  def self.configure
    yield config if block_given?
    config
  end

  self.config = Config.new
end

require 'moo_moo/services/lookup'
require 'moo_moo/services/nameserver'
require 'moo_moo/services/provisioning'
require 'moo_moo/services/transfer'
require 'moo_moo/services/dns_zone'
require 'moo_moo/services/cookie'

Faraday::Request.register_middleware  :open_srs_xml_builder => MooMoo::OpenSRSXMLBuilder
Faraday::Response.register_middleware :open_srs_errors => MooMoo::OpenSRSErrors, :parse_open_srs => MooMoo::ParseOpenSRS
