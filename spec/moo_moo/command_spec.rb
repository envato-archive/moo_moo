require 'spec_helper'

describe MooMoo::Command do

  let(:command) { MooMoo::Command.new("theaction", "thecommand") }

  it "raises exception on invalid http status" do
    VCR.use_cassette("command/invalid_http_status") do
      lambda { command.run("thehost", "thekey", "theuser", "12345") }.should raise_error(MooMoo::OpenSRSException, "Bad HTTP Status: 404")
    end
  end
end