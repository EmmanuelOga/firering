require 'spec_helper'

TestData = Struct.new(:connection, :a, :b)

class TestData
  extend Firering::Instantiator
end

describe Firering::Instantiator do
  before do
    @logger = mock("logger")
    @connection = mock("connection", :logger => @logger)
  end

  it "initializes an object from a hash with a base key" do
    object = TestData.instantiate(@connection, {:test_data => { :a => 1, :b => 2}}, :test_data)
    object.a.should == 1
    object.b.should == 2
    object.connection.should == @connection
  end

  it "warns when attributes don't exist on the struct" do
    @logger.should_receive(:warn).with("Couldn't set attribute 'c' to value '3' on TestData object")
    object = TestData.instantiate(@connection, {:test_data => {:c => 3}}, :test_data)
    lambda { object.c }.should raise_error(NoMethodError)
  end

end
