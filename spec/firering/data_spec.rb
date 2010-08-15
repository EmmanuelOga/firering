require 'spec_helper'

class TestData < Firering::Data
  data_attributes :a, :b
end

describe Firering::Data do

  it "initializes an object from a hash with a base key, and defines accessors" do
    object = TestData.instantiate(:connection, {:test_data => { :a => 1, :b => 2}}, :test_data)
    object.a.should == 1
    object.b.should == 2
    object.connection.should == :connection
  end

end
