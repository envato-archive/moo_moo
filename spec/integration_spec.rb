require 'spec_helper'

describe "Real World integration" do

  it "Lookup should work" do
    lookup = MooMoo::Lookup.new

    VCR.use_cassette("integration/lookup") do
      response = lookup.lookup_domain(:domain => "opensrs.net")
      pp response
      response.result["status"].should == "taken"
    end
  end

end