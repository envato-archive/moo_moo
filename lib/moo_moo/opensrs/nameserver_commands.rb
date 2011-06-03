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
      def create_nameserver(attribs)
        Args.new(attribs) do |c|
          c.requires :name, :ip, :domain
          c.optionals :cookie
        end

        cookie = attribs.delete :cookie
        run_command :create, :nameserver, attribs, cookie
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
      def delete_nameserver(attribs, cookie = nil)
        Args.new(attribs) do |c|
          c.requires :name, :ip, :domain
          c.optionals :cookie
        end

        cookie = attribs.delete :cookie
        run_command :delete, :nameserver, attribs, cookie
      end

      # Queries nameservers that exist for the given domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - domain profile to query
      def get_nameserver(domain)
        run_command :get, :nameserver, {
          :name => 'all',
          :domain => domain,
          :key => 'attributes'
        }
      end

      # Renames a nameserver
      #
      # ==== Required
      #  * <tt>:name</tt> - current name of the nameserver
      #  * <tt>:ip</tt> - ip address of the name server
      #  * <tt>:new_name</tt> - new name for the nameserver
      #  * <tt>:domain</tt> - domain profile the nameserver was created for
      def modify_nameserver(attribs)
        Args.new(attribs) do |c|
          c.requires :name, :ip, :new_name, :domain
        end

        run_command :modify, :nameserver, attribs
      end
    end
  end
end
