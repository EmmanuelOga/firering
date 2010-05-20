require 'spec_helper'

class TestData < Firering::Data
  key :a, :b
end

describe Firering::Data do

  it "can be initialized from a hash" do
    object = TestData.new({:testdata => { :a => 1, :b => 2}}, :testdata)
    object.a.should == 1
    object.b.should == 2
  end

  it "can be initialized from a json string" do
    object = TestData.new('{"testdata" : { "a" : 1, "b" : 2}}', :testdata)
    object.a.should == 1
    object.b.should == 2
  end

end
