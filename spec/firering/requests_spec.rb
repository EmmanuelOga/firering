require 'spec_helper'
require 'date'

Firering::Streaming.protocol = "http"
Firering::Streaming.host = "localhost:4567"

Firering::HTTP.host = "localhost:4567"

describe "firering" do

  it "authenticates a user" do
    EM.run {
      Firering.authenticate(nil, "user", "password") do |user|
        user.token.should == "token"
        EM.stop
      end
    }
  end

  it "gets a user info" do
    EM.run {
      Firering.user(415731) do |user|
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

  it "gets a single room" do
    EM.run {
      Firering.room(304355) do |room|
        room.name.should == "test2"
        room.created_at.should == Date.parse("2010/05/29 21:38:02 +0000")
        room.updated_at.should == Date.parse("2010/05/29 21:38:02 +0000")
        room.topic.should == "this and the test room should be deleted by a campfire admin."
        room.should_not be_full
        room.id.should == 304355
        room.should_not be_open_to_guests
        room.membership_limit.should == 12
        room.should_not be_locked

        room.users.each do |u|
          u.should be_an_instance_of(Firering::User)
        end

        EM.stop
      end
    }
  end

  it "gets multiple rooms without performing multiple requests per room" do
    EM.run {
      Firering.rooms(false) do |rooms|
        rooms.each do |room|
          room.should be_an_instance_of(Firering::Room)
          room.users.should be_an_instance_of(Array)
        end
        EM.stop
      end
    }
  end

  it "gets multiple rooms performing multiple requests per room" do
    EM.run {
      Firering.rooms do |rooms|
        rooms.each do |room|
          room.should be_an_instance_of(Firering::Room)
          room.users.should be_an_instance_of(Array)
        end

        EM.stop
      end
    }
  end

  it "updates a room and then calls the block" do
    EM.run {
      Firering.update_room(304355, :topic => "some topic") do
        EM.stop
      end
    }
  end

  it "gets a collection of recent messages" do
    EM.run {
      Firering.room_recent_messages(304355) do |messages|

        messages.each do |m|
          m.should be_an_instance_of(Firering::Message)
        end

        message = messages.first
        message.should be_timestamp
        message.room_id.should == 304355
        message.created_at.should == Date.parse("2010/05/29 22:05:00 +0000")
        message.body.should be_nil
        message.id.should == 224587718
        message.user_id.should be_nil

        EM.stop
      end
    }
  end

  it "returns a collection of messages matching certain pattern" do
    EM.run {
      Firering.search_messages("harmless") do |messages|

        messages.length.should == 3

        messages.each do |m|
          m.should be_an_instance_of(Firering::Message)
        end

        message = messages.last
        message.should be_text
        message.room_id.should == 177718
        message.created_at.should == Date.parse("2009/06/02 21:20:32 +0000")
        message.body.should == "q: should i add :case_sensitive =\u003E false to the validation of title name? Looks harmless but who knows..."
        message.id.should == 134405854
        message.user_id.should == 415731

        EM.stop
      end
    }
  end

  it "returns the messages of today for a given room" do
    EM.run {
      Firering.today_messages(304355) do |messages|

        messages.length.should == 33

        messages.each do |m|
          m.should be_an_instance_of(Firering::Message)
        end

        message = messages.last

        message.should be_paste
        message.room_id.should == 304355
        message.created_at.should == Date.parse("2010/05/29 22:41:34 +0000")
        message.body.should == "paste\ntext"
        message.id.should == 224590114
        message.user_id.should == 415731

        EM.stop
      end
    }
  end

  it "joins a room an call a block" do
    EM.run { Firering.room_join(304355) { EM.stop } }
  end

  it "leaves a room an call a block" do
    EM.run { Firering.room_leave(304355) { EM.stop } }
  end

  it "unlocks a room an call a block" do
    EM.run { Firering.room_unlock(304355) { EM.stop } }
  end

  it "is able to speak a text message" do
    EM.run { Firering.text(304355, "some text") { EM.stop } }
  end

  it "is able to speak a paste message" do
    EM.run { Firering.paste(304355, "some\ntext") { EM.stop } }
  end

  it "is able to speak a tweet" do
    EM.run { Firering.tweet(304355, "http://twitter.com/message") { EM.stop } }
  end

  it "is able to play a rimshot" do
    EM.run { Firering.rimshot(304355) { EM.stop } }
  end

  it "is able to play crickets" do
    EM.run { Firering.crickets(304355) { EM.stop } }
  end

  it "is able to play a trombone" do
    EM.run { Firering.trombone(304355) { EM.stop } }
  end

  it "is able to highlight / de-highlight a message" do
    EM.run {
      Firering.highlight_message(224590113) {
        Firering.highlight_message(224590113, false) {
          EM.stop
        }
      }
    }
  end

end
