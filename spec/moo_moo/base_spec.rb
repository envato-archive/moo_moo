require 'spec_helper'

class SampleService < MooMoo::Base
  register_service :service1, :object1
  register_service :service2, :object2, :action2
  register_service :service3, :object3 do |params|
    params[:example] = "theexample"
  end
end

describe MooMoo::Base do

  before :each do
    @service = SampleService.new
  end

  describe "class methods" do
    describe "register_service" do
      context "calls the services with the given parameters" do
        it "service1" do
          params = {:the => :params, :cookie => "thecookie"}

          @service.should_receive(:run_command)
                  .with(:service1, :object1, params, "thecookie")
                  .and_return("theresult")

          @service.service1(params).should == "theresult"
        end

        it "service2" do
          params = {:the => :params, :cookie => "thecookie"}

          @service.should_receive(:run_command)
                  .with(:action2, :object2, params, "thecookie")
                  .and_return("theresult")

          @service.service2(params).should == "theresult"
        end

        it "service3" do
          params = {:the => :params, :cookie => "thecookie"}
          expected_params = {:the => :params, :key => "attributes", :example => "theexample"}

          @service.should_receive(:run_command)
                  .with(:service3, :object3, expected_params, "thecookie")
                  .and_return("theresult")

          @service.service3(params).should == "theresult"
        end
      end
    end
  end

  describe "run_command" do
    it "should parse result as a hash" do
      xml = File.open("spec/fixtures/success_response.xml")
      FakeWeb.register_uri(:post, "https://server.com:55443/", :body => xml)

      @service.run_command(:action, :object).result["response_text"].should == "Command Successful"
    end
  end

  describe "#try_opensrs" do
    it "raises an OpenSRSException" do
      expect do
        MooMoo::Base.new.instance_eval do
          try_opensrs { raise "Exception message" }
        end
      end.to raise_error MooMoo::OpenSRSException
    end
  end
end