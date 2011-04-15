require 'moomoo/opensrs/command'
require 'moomoo/opensrs/opensrsexception'
require 'moomoo/opensrs/utils'
require 'moomoo/opensrs/lookup_commands'
require 'moomoo/opensrs/provisioning_commands'
require 'moomoo/opensrs/transfer_commands'
require 'moomoo/opensrs/nameserver_commands'

module MooMoo
  class OpenSRS
    include Utils

    attr_reader :port

    include LookupCommands
    include ProvisioningCommands
    include TransferCommands
    include NameserverCommands

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

    def can_register?(domain)
      try_opensrs do
        cmd = Command.new('lookup', 'domain', {"domain" => domain})
        result = run_command(cmd)

        case result['response_code'].to_i
          when 210
            true
          when 211
            false
          else
            errors = [result['rrptext1']]
            raise OpenSRSException.new(errors), "Unexpected response from domain registry."
        end
      end
    end

    def can_transfer?(domain)
      try_opensrs do
        cmd = Command.new('check_transfer', 'domain', {"domain" => domain})
        result = run_command(cmd)

        p result.inspect
        case result['response_code'].to_i
          when 200
            result['transferrable'].to_i == 1
          else
            errors = [result['rrptext1']]
            raise OpenSRSException.new(errors), "Unexpected response from domain registry."
        end
      end
    end

    def can_update?(domain)
      try_opensrs do
        cmd = Command.new('belongs_to_rsp', 'domain', {"domain" => domain})
        result = run_command(cmd)

        result['attributes']['belongs_to_rsp'].to_i == 1
      end
    end

    def can_register_list?(*domains)
      try_opensrs do
        results = []
        domains.each do |domain|
          begin
            results << can_register?(domain)
          rescue Exception => e
            results << false
          end
        end

        results
      end
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
