require 'spec_helper'

TestData = Struct.new(:connection, :a, :b)

class TestData
  extend Firering::Instantiator
end

describe Firering::Instantiator do

  it "initializes an object from a hash with a base key" do
    object = TestData.instantiate(:connection, {:test_data => { :a => 1, :b => 2}}, :test_data)
    object.a.should == 1
    object.b.should == 2
    object.connection.should == :connection
  end

end
