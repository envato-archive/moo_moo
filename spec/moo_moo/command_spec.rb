require 'spec_helper'

describe MooMoo::Command do

  let(:action)  { "theaction" }
  let(:object)  { "theobject" }
  let(:params)  { {
    :string => "stringparam",
    :hash => {:the => "hashparam"},
    :array => [{:param => "arrayvalue1"}, {:param => "arrayvalue2"}],
    :array_list => ["arrayvalue1", "arrayvalue2"]
  } }
  let(:cookie)  { "thecookie" }

  let(:command) { MooMoo::Command.new(action, object, params, cookie) }

  describe "#run" do
    describe "success response" do
      let(:xml)      { "xmlcontent" }
      let(:response) { {:status => 200, :body => File.open("spec/fixtures/success_response.xml")} }

      before :each do
        @request = stub_request(:post, "https://thehost.com:12345/").to_return(response)
        @response = command.run("thehost.com", "thekey", "theuser", "12345")
      end

      it "posts with correct parameters" do
        @request.should have_been_made
      end

      it "returns the response" do
        @response["response_text"].should == "Command Successful"
      end
    end

    it "raises exception on invalid http status" do
      stub_request(:post, "https://thehost:12345/").to_return(:status => ["401", "Unauthorized"])
      lambda { command.run("thehost", "thekey", "theuser", "12345") }.should raise_error(MooMoo::OpenSRSException, "Bad HTTP Status: 401")
    end
  end

end