require 'spec_helper'

describe Firering::Connection do

  it "authenticates a user" do
    EM.run {
      conn.authenticate do |user|
        user.token.should == "token"
        EM.stop
      end
    }
  end

  it "stream messages" do
    EM.run {
      conn.stream(304355) do |message|
        message.should be_an_instance_of(Firering::Message)
      end
      EM.add_timer(1) do
        EM.stop
      end
    }
  end

end
