require 'moomoo/opensrs/command'
require 'moomoo/opensrs/response'
require 'moomoo/opensrs/opensrsexception'
require 'moomoo/opensrs/utils'
require 'moomoo/opensrs/lookup_commands'
require 'moomoo/opensrs/provisioning_commands'
require 'moomoo/opensrs/transfer_commands'
require 'moomoo/opensrs/nameserver_commands'
require 'moomoo/opensrs/cookie_commands'

module MooMoo
  class OpenSRS
    include Utils

    include LookupCommands
    include ProvisioningCommands
    include TransferCommands
    include NameserverCommands
    include CookieCommands

    def initialize(host, key, user, password)
      @host = host
      @key = key
      @user = user
      @password = password
      @port = 55443
    end

    def run_command(command)
      command.run(@host, @key, @user, @port)
    end

    private

    def index_array(arr)
      arr_indexed = {}

      arr.each_with_index do |item, index|
        arr_indexed[index] = item
      end

      arr_indexed
    end
  end
end
