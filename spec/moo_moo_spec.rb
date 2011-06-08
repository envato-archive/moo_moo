require 'spec_helper'

describe MooMoo do
  describe "::Version" do
    it "has a valid version" do
      MooMoo::Version.should match /\d+\.\d+\.\d+/
    end
  end

  describe "::configure" do
    it { MooMoo.configure.should be_a MooMoo::Config }
  end

  describe "::config" do
    it { MooMoo.should have_attr_accessor :config }
  end
end
