require 'spec_helper'
require 'moomoo/opensrs'

module MooMoo

  describe OpenSRS do
    before(:each) do
      @opensrs = OpenSRS.new(@opensrs_host, @opensrs_key, @opensrs_user, @opensrs_pass)
    end

  end
end
