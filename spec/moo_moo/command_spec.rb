require 'spec_helper'

describe MooMoo::Command do

  let(:action)  { "theaction" }
  let(:object)  { "theobject" }
  let(:params)  { {:string => "stringparam", :hash => {:the => "hashparam"}, :array => [{"0".to_sym => {:param => "arrayvalue"}}]} }
  let(:cookie)  { "thecookie" }

  let(:command) { MooMoo::Command.new(action, object, params, cookie) }

  describe "#run" do
    describe "success response" do
      let(:xml)      { "xmlcontent" }
      let(:response) { {:the => :response} }

      before :each do
        command.stub(:build_command => xml, :parse_response => response, :signature => "thesignature")

        @request = stub_request(:post, "https://thehost.com:12345/").with(
          :body => xml,
          :headers => {
            'Content-Type'   => 'text/xml',
            'Content-Length' => xml.size.to_s,
            'X-Username'     => "theuser",
            'X-Signature'    => "thesignature"
          }
        )

        @response = command.run("thehost.com", "thekey", "theuser", "12345")
      end

      it "posts with correct parameters" do
        @request.should have_been_made
      end

      it "returns the response" do
        @response.should == response
      end
    end

    it "raises exception on invalid http status" do
      stub_request(:post, "https://thehost:12345/").to_return(:status => ["401", "Unauthorized"])
      lambda { command.run("thehost", "thekey", "theuser", "12345") }.should raise_error(MooMoo::OpenSRSException, "Bad HTTP Status: 401")
    end
  end

  describe "#build_command" do
    before :each do
      @body = command.send(:build_command)
    end

    it "should set the action" do
      @body.root.elements["body/data_block/dt_assoc/item[@key='action']"].text.should == "theaction"
    end

    it "should set the object" do
      @body.root.elements["body/data_block/dt_assoc/item[@key='object']"].text.should == "theobject"
    end

    it "should set the the cookie" do
      @body.root.elements["body/data_block/dt_assoc/item[@key='cookie']"].text.should == "thecookie"
    end

    describe "attributes" do
      it "should set string params" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='string']"].text.should == "stringparam"
      end

      it "should set hash params" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='hash']/dt_assoc/item[@key='the']"].text.should == "hashparam"
      end

      it "should set array params" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='array']/dt_array/item[@key='0']/dt_assoc/item[@key='param']"].text.should == "arrayvalue"
      end
    end
  end

  describe "#parse_response" do
    it "should retrieve the response" do
      xml = File.open("spec/fixtures/success_response.xml")
      command.send(:parse_response, xml)["response_text"].should == "Command Successful"
    end
  end
end