require 'spec_helper'

if live_test?
  describe "Real World integration" do

    it "Lookup should work" do
      lookup = MooMoo::Lookup.new

      VCR.use_cassette("integration/lookup") do
        response = lookup.lookup_domain(:domain => "opensrs.net")

        response.result["status"].should == "taken"
      end
    end

  end
end