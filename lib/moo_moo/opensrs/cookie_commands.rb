module MooMoo
  module OpenSRS
    module CookieCommands
      # Creates a cookie for a domain
      #
      # ==== Required
      #  * <tt>:username</tt> - username of the registrant
      #  * <tt>:password</tt> - password of the registrant
      #  * <tt>:domain</tt> - domain to set the cookie for
      def set_cookie(params)
        run_command :set, :cookie, {
          :reg_username => params[:username],
          :reg_password => params[:password],
          :domain => params[:domain],
          :key => 'attributes'
        }
      end

      # Deletes a cookie that was previously set
      #
      # ==== Required
      #  * <tt>:cookie</tt> - cookie to delete
      def delete_cookie(cookie)
        run_command :delete, :cookie, {
          :cookie => cookie
        }, cookie
      end

      # Updates a cookie to be valid for a different domain
      #
      # ==== Required
      #  * <tt>:old_domain</tt> - domain the cookie is currently set for
      #  * <tt>:new_domain</tt> - domain to set the cookie for
      #  * <tt>:cookie</tt> - cookie to update
      def update_cookie(attribs)
        run_command :update, :cookie, {
          :reg_username => MooMoo.config.user,
          :reg_password => '',
          :domain => attribs[:old_domain],
          :domain_new => attribs[:new_domain],
          :key => 'attributes'
        }, attribs[:cookie]
      end

      # Cleanly terminates the connection
      #
      def quit_session
        run_command :quit, :session
      end
    end
  end
end
