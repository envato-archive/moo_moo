require 'spec_helper'

describe MooMoo::OpenSRS::Base do
  describe "#try_opensrs" do
    it "raises an OpenSRSException" do
      expect do
        MooMoo::OpenSRS::Base.new.instance_eval do
          try_opensrs { raise "Exception message" }
        end
      end.to raise_error MooMoo::OpenSRSException
    end
  end
end
