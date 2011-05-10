module MooMoo
  class OpenSRS
    module NameserverCommands
      # Creates a nameserver
      #
      # ==== Required
      #  * <tt>:name</tt> - name of the nameserver
      #  * <tt>:ip</tt> - ip address for the nameserver
      #  * <tt>:domain</tt> - domain name to create it for
      #
      # ==== Optional
      #  * <tt>:cookie</tt> - cookie for domain
      def create_nameserver(name, ip, domain, cookie = nil)
        try_opensrs do
          cmd = Command.new('create', 'nameserver', {"name" => name, "ipaddress" => ip, "domain" => domain}, cookie)
          result = run_command(cmd)

          OpenSRS::Response.new(result)
        end
      end

      # Deletes a nameserver
      #
      # ==== Required
      #  * <tt>:name</tt> - name of the nameserver
      #  * <tt>:ip</tt> - ip address for the nameserver
      #  * <tt>:domain</tt> - domain name to create it for
      #
      # ==== Optional
      #  * <tt>:cookie</tt> - cookie for domain
      def delete_nameserver(name, ip, domain, cookie = nil)
        try_opensrs do
          cmd = Command.new('delete', 'nameserver', {"name" => name, "ipaddress" => ip, "domain" => domain}, cookie)
          result = run_command(cmd)

          OpenSRS::Response.new(result)
        end
      end

      # Queries nameservers that exist for the given domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain profile to query
      def get_nameserver(domain)
        try_opensrs do
          cmd = Command.new('get', 'nameserver', {"name" => "all", "domain" => domain})
          result = run_command(cmd)

          OpenSRS::Response.new(result, 'attributes')
        end
      end

      # Renames a nameserver
      #
      # ==== Required
      #  * <tt>:name</tt> - current name of the nameserver
      #  * <tt>:ip</tt> - ip address of the name server
      #  * <tt>:new_name</tt> - new name for the nameserver
      #  * <tt>:domain</tt> - domain profile the nameserver was created for
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
