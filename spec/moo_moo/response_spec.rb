require 'spec_helper'

describe MooMoo::Response do

  let(:response) { MooMoo::Response.new({ :the => :value, :some => { :nested => :other_value } }) }

  it "can retrieve values like a hash" do
    response[:the].should == :value
    response[:some][:nested].should == :other_value
  end

  it "can retrieve values like an object" do
    response.the.should == :value
    response.some.nested.should == :other_value
  end

  context "#success?" do
    it "retrieves true if success" do
      response['is_success'] = "1"
      response.should be_success
    end

    it "retrieves false if not success" do
      response['is_success'] = "0"
      response.should_not be_success
    end
  end

end