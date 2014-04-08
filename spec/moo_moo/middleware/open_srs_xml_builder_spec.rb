require 'spec_helper'

describe MooMoo::OpenSRSXMLBuilder do

  describe "#build_command" do
    before :each do
      params =  {
        :cookie        => "thecookie",
        :domain        => "mydomain.com",
        :registrant_ip => "theregistrantip",
        :attributes    => {
          :string     => "stringparam",
          :hash       => {:the => "hashparam"},
          :array      => [{:param => "arrayvalue1"}, {:param => "arrayvalue2"}],
          :array_list => ["arrayvalue1", "arrayvalue2"]
        }
      }

      middleware = described_class.new(lambda{|env| env}, "theaction", "theobject", params, "key")
      env = {:body => nil, :request_headers => Faraday::Utils::Headers.new}
      result = middleware.call(env)
      @body = REXML::Document.new(result[:body])
    end

    it "should set the action" do
      @body.root.elements["body/data_block/dt_assoc/item[@key='action']"].text.should == "theaction"
    end

    it "should set the object" do
      @body.root.elements["body/data_block/dt_assoc/item[@key='object']"].text.should == "theobject"
    end

    it "should set the registrant_ip" do
      @body.root.elements["body/data_block/dt_assoc/item[@key='registrant_ip']"].text.should == "theregistrantip"
    end

    it "should set the the cookie" do
      @body.root.elements["body/data_block/dt_assoc/item[@key='cookie']"].text.should == "thecookie"
    end

    describe "attributes" do
      it "should set the domain param" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='domain']"].text.should == "mydomain.com"
      end

      it "should set string params" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='string']"].text.should == "stringparam"
      end

      it "should set hash params" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='hash']/dt_assoc/item[@key='the']"].text.should == "hashparam"
      end

      it "should set array params" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='array']/dt_array/item[@key='0']/dt_assoc/item[@key='param']"].text.should == "arrayvalue1"
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='array']/dt_array/item[@key='1']/dt_assoc/item[@key='param']"].text.should == "arrayvalue2"
      end

      it "should set array list params" do
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='array_list']/dt_array/item[@key='0']"].text.should == "arrayvalue1"
        @body.root.elements["body/data_block/dt_assoc/item[@key='attributes']/dt_assoc/item[@key='array_list']/dt_array/item[@key='1']"].text.should == "arrayvalue2"
      end
    end
  end

end
