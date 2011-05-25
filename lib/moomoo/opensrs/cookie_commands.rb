module MooMoo
  class OpenSRS
    module CookieCommands
      # Creates a cookie for a domain
      #
      # ==== Required
      #  * <tt>:username</tt> - username of the registrant
      #  * <tt>:password</tt> - password of the registrant
      #  * <tt>:domain</tt> - domain to set the cookie for
      def set_cookie(username, password, domain)
        try_opensrs do
          cmd = Command.new('set', 'cookie', {
            "reg_username" => username, 
            "reg_password" => password, 
            "domain" => domain
            })
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Deletes a cookie that was previously set
      #
      # ==== Required
      #  * <tt>:cookie</tt> - cookie to delete
      def delete_cookie(cookie)
        try_opensrs do
          cmd = Command.new('delete', 'cookie', {"cookie" => cookie}, cookie)
          result = run_command(cmd)

          Response.new(result)
        end
      end

      # Updates a cookie to be valid for a different domain
      #
      # ==== Required
      #  * <tt>:old_domain</tt> - domain the cookie is currently set for
      #  * <tt>:new_domain</tt> - domain to set the cookie for
      #  * <tt>:cookie</tt> - cookie to update
      def update_cookie(attribs)
        try_opensrs do
          cmd = Command.new('update', 'cookie', {
            "reg_username" => @opensrs_user, 
            "reg_password" => "", 
            "domain" => attribs[:old_domain], 
            "domain_new" => attribs[:new_domain]
            }, attribs[:cookie])
          result = run_command(cmd)

          Response.new(result, 'attributes')
        end
      end

      # Cleanly terminates the connection
      #
      def quit_session
        try_opensrs do
          cmd = Command.new('quit', 'session')
          result = run_command(cmd)

          Response.new(result)
        end
      end
    end
  end
end
