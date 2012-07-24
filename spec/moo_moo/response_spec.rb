require 'spec_helper'
require 'date'

describe MooMoo::Response do
  subject { MooMoo::Response.new(
    "is_success" => "1", "response_code" => "100",
    "response_text" => "The message", "attributes" => "The attributes") }

  describe "#hash" do
    it "retrieves the response hash" do
      subject.hash.should == { "is_success" => "1", "response_code" => "100",
        "response_text" => "The message", "attributes" => "The attributes" }
    end
  end

  describe "#success?" do
    it "is true when 1" do
      subject.success?.should be_true
    end

    it "is false when not 1" do
      MooMoo::Response.new("is_success" => "0").success?.should be_false
    end
  end

  describe "#code" do
    it "retrieves response code" do
      subject.code.should == 100
    end
  end

  describe "#text" do
    it "retrieves response text" do
      subject.text.should == "The message"
    end
  end

  describe "#attributes" do
    it "retrieves response attributes" do
      subject.attributes.should == "The attributes"
    end
  end
end