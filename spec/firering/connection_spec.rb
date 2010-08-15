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

end
