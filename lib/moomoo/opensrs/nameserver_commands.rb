module MooMoo
  class OpenSRS
    module NameserverCommands
      def create_nameserver(name, ip, domain, cookie = nil)
        try_opensrs do
          cmd = Command.new('create', 'nameserver', {"name" => name, "ipaddress" => ip, "domain" => domain}, cookie)
          result = run_command(cmd)

          OpenSRS::Response.new(result)
        end
      end

      def delete_nameserver(name, ip, domain, cookie = nil)
        try_opensrs do
          cmd = Command.new('delete', 'nameserver', {"name" => name, "ipaddress" => ip, "domain" => domain}, cookie)
          result = run_command(cmd)

          OpenSRS::Response.new(result)
        end
      end

      def get_nameserver(domain)
        try_opensrs do
          cmd = Command.new('get', 'nameserver', {"name" => "all", "domain" => domain})
          result = run_command(cmd)

          OpenSRS::Response.new(result, 'attributes')
        end
      end

      def modify_nameserver(name, ip, new_name, domain)
        try_opensrs do
          cmd = Command.new('modify', 'nameserver', {"name" => name, "ipaddress" => ip, "new_name" => new_name, "domain" => domain})
          result = run_command(cmd)

          OpenSRS::Response.new(result)
        end
      end
    end
  end
end
