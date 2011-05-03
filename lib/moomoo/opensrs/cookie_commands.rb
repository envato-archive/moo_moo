module MooMoo
  class OpenSRS
    module CookieCommands
      def set_cookie(username, password, domain)
        try_opensrs do
          cmd = Command.new('set', 'cookie', {"reg_username" => username, "reg_password" => password, "domain" => domain})
          result = run_command(cmd)

          OpenSRS::Response.new(result, 'attributes')
        end
      end

      def delete_cookie(cookie)
        try_opensrs do
          cmd = Command.new('delete', 'cookie', {"cookie" => cookie}, cookie)
          result = run_command(cmd)

          OpenSRS::Response.new(result)
        end
      end

      def update_cookie(old_domain, new_domain, cookie)
        try_opensrs do
          cmd = Command.new('update', 'cookie', {"reg_username" => @opensrs_user, "reg_password" => "", "domain" => old_domain, "domain_new" => new_domain}, cookie)
          result = run_command(cmd)

          OpenSRS::Response.new(result, 'attributes')
        end
      end

      def quit_session
        try_opensrs do
          cmd = Command.new('quit', 'session')
          result = run_command(cmd)

          OpenSRS::Response.new(result)
        end
      end
    end
  end
end
