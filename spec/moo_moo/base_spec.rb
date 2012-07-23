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
    @service = SampleService.new("thehost", "thekey", "theuser", "thepass", "theport")
  end

  describe "class methods" do
    describe "#register_service" do
      context "calls the services with the given parameters" do
        it "service1" do
          params = {:the => :params, :cookie => "thecookie"}

          @service.should_receive(:run_command).
                  with(:service1, :object1, params).
                  and_return("theresult")

          @service.service1(params).should == "theresult"
        end

        it "service2" do
          params = {:the => :params, :cookie => "thecookie"}

          @service.should_receive(:run_command).
                  with(:action2, :object2, params).
                  and_return("theresult")

          @service.service2(params).should == "theresult"
        end

        it "service3" do
          params = {:the => :params, :cookie => "thecookie"}
          expected_params = {:the => :params, :cookie => "thecookie", :example => "theexample"}

          @service.should_receive(:run_command).
                  with(:service3, :object3, expected_params).
                  and_return("theresult")

          @service.service3(params).should == "theresult"
        end
      end
    end
  end

  describe "#run_command" do
    it "should encapsulate response" do
      result  = {:the => :result}
      command = stub()
      command.should_receive(:run).with("thehost", "thekey", "theuser", "theport").and_return(result)
      MooMoo::Command.should_receive(:new).
                     with("theaction", "theobject", {"the" => "params"}).
                     and_return(command)

      response = @service.run_command("theaction", "theobject", {"the" => "params"})
      response.hash.should == result
    end
  end
end