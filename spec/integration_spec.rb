require 'spec_helper'

describe "Real World integration" do

  it "Lookup should work" do
    lookup = MooMoo::Lookup.new

    VCR.use_cassette("integration/lookup") do
      lookup.api_lookup(:domain => "opensrs.net")
      lookup.attributes["status"].should == "taken"
    end
  end

end