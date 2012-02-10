require 'spec_helper'

describe MooMoo::Command do

  let(:command) { MooMoo::Command.new("theaction", "thecommand") }

  it "should send valid xml request"

  it "raises exception on invalid http status" do
    FakeWeb.register_uri(:post, "https://thehost:12345/", :status => ["401", "Unauthorized"])

    lambda { command.run("thehost", "thekey", "theuser", "12345") }.should raise_error(MooMoo::OpenSRSException, "Bad HTTP Status: 401")
  end

  it "should parse result as a hash" do
    xml = File.open("spec/fixtures/success_response.xml")
    FakeWeb.register_uri(:post, "https://thehost:12345/", :body => xml)

    command.run("thehost", "thekey", "theuser", "12345")["response_text"].should == "Command Successful"
  end
end