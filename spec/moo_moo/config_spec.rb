require 'spec_helper'

describe MooMoo::Config do
  before :each do
    @config = MooMoo::Config.new
  end

  it { @config.should have_attr_accessor :host }
  it { @config.should have_attr_accessor :key  }
  it { @config.should have_attr_accessor :username }
  it { @config.should have_attr_accessor :password }
  it { @config.should have_attr_accessor :port }

  describe "default configuration" do
    before :each do
      File.should_receive(:exists?).with(".moomoo.yml").and_return(true)
      File.should_receive(:open).with(".moomoo.yml").and_return(
        "
        host: thehost
        key: thekey
        username: theuser
        password: thepass
        port: theport
        "
      )

      @config = MooMoo::Config.new
    end

    it "should set default host from default options file" do
      @config.host.should == "thehost"
    end

    it "should set default key from default options file" do
      @config.key.should == "thekey"
    end

    it "should set default user from default options file" do
      @config.username.should == "theuser"
    end

    it "should set default pass from default options file" do
      @config.password.should == "thepass"
    end

    it "should set default port from default options file" do
      @config.port.should == "theport"
    end
  end
end
