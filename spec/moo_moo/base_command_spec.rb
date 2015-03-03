require 'spec_helper'

class SampleService < MooMoo::BaseCommand
  register_service :service1, :object1
end

describe MooMoo::BaseCommand do

  subject { SampleService.new(:host => "thehost.com", :key => "thekey",
      :username => "theuser", :port => "12345") }

  let(:response) { double("Response", :body => {"attributes" => { :the => :attrs }})}

  describe "class methods" do
    describe "#register_service" do
      let(:request_params) { {:the => :params, :cookie => "thecookie"} }

      it "service1" do
        subject.should_receive(:faraday_request).
                with(:service1, :object1, request_params).
                and_return(response)

        subject.api_service1(request_params).should_not == {:the => :attrs}
      end
    end
  end

  describe "#successful?" do
    it "is successful" do
      subject.instance_variable_set("@response",
        double("Response", :body => { "is_success" => "1" }))

      subject.should be_successful
    end

    it "is not successful" do
      subject.instance_variable_set("@response",
        double("Response", :body => { "is_success" => "0" }))

      subject.should_not be_successful
    end
  end

  describe "#message" do
    it "retrives the response text" do
      subject.instance_variable_set("@response",
        double("Response", :body => { "response_text" => "thetext" }))

      subject.message.should == "thetext"
    end
  end

  describe "#response_attributes" do
    it "retrives the response attributes" do
      subject.instance_variable_set("@response",
        double("Response", :body => { "attributes" => { :the => :attributes } }))

      subject.attributes.should == { :the => :attributes }
    end
  end

  describe "#perform" do
    let(:xml)      { "xmlcontent" }
    let(:response) { {:status => 200, :body => File.open("spec/fixtures/success_response.xml")} }

    before :each do
      @request  = stub_request(:post, "https://thehost.com:12345/").to_return(response)
      subject.send(:perform, :service1, :object1)
    end

    it "posts with correct parameters" do
      @request.should have_been_made
    end

    it "returns the response" do
      subject.message.should == "Command Successful"
    end
  end
end
