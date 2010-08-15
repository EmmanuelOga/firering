require 'spec_helper'

describe Firering::User do

  it "gets a user info" do
    EM.run {
      conn.user(415731) do |user|

        user.type.should == "Member"
        user.created_at.should == Date.parse("2009/01/27 19:54:36 +0000")
        user.email_address.should == "eoga@mail.com"
        user.should_not be_admin
        user.id.should == 415731
        user.name.should == "Emmanuel"

        EM.stop
      end
    }
  end

end
