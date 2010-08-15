require 'spec_helper'

describe Firering::Room do

  it "gets a single room" do
    EM.run {
      conn.room(304355) do |room|

        room.name.should == "test2"
        room.created_at.should == Date.parse("2010/05/29 21:38:02 +0000")
        room.updated_at.should == Date.parse("2010/05/29 21:38:02 +0000")
        room.topic.should == "this and the test room should be deleted by a campfire admin."
        room.should_not be_full
        room.id.should == 304355
        room.should_not be_open_to_guests
        room.membership_limit.should == 12
        room.should_not be_locked

        room.users do |users|
          users.each do |u|
            u.should be_an_instance_of(Firering::User)
          end
        end

        EM.stop
      end
    }
  end

  it "gets all rooms" do
    EM.run {
      conn.rooms do |rooms|
        rooms.each do |room|
          room.should be_an_instance_of(Firering::Room)
          room.users do |users|
            users.should be_an_instance_of(Array)
            users.should_not be_empty
          end
        end
        EM.stop
      end
    }
  end

  it "updates a room and then calls the block" do
    EM.run {
      conn.room(304355) do |room|
        room.update(:topic => "some topic") do
          EM.stop
        end
      end
    }
  end

  it "returns the messages of today for a given room" do
    EM.run {
      conn.room(304355) do |room|
        room.today_transcript do |messages|
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
      end
    }
  end

  it "returns the messages of an specific date for a given room" do
    EM.run {
      conn.room(304355) do |room|
        room.transcript(2010, 12, 12) do |messages|

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
      end
    }
  end

  it "joins a room" do
    EM.run {
      conn.room(304355) { |room|
        room.join {
          EM.stop
        }
      }
    }
  end

  it "leaves a room" do
    EM.run {
      conn.room(304355) { |room|
        room.leave {
          EM.stop
        }
      }
    }
  end

  it "unlocks a room an call a block" do
    EM.run {
      conn.room(304355) { |room|
        room.unlock {
          EM.stop
        }
      }
    }
  end

  it "locks a room an call a block" do
    EM.run {
      conn.room(304355) { |room|
        room.lock {
          EM.stop
        }
      }
    }
  end

  it "is able to speak a text message" do
    EM.run {
      conn.room(304355) { |room|
        room.text("some text") {
          EM.stop
        }
      }
    }
  end

  it "is able to speak a paste message" do
    EM.run {
      conn.room(304355) { |room|
        room.paste("some\ntext") {
          EM.stop
        }
      }
    }
  end

  it "is able to speak a tweet" do
    EM.run {
      conn.room(304355) { |room|
        room.tweet("http://twitter.com/message") {
          EM.stop
        }
      }
    }
  end

  it "is able to play a rimshot" do
    EM.run {
      conn.room(304355) { |room|
        room.rimshot {
          EM.stop
        }
      }
    }
  end

  it "is able to play crickets" do
    EM.run {
      conn.room(304355) { |room|
        room.crickets {
          EM.stop
        }
      }
    }
  end

  it "is able to play a trombone" do
    EM.run {
      conn.room(304355) { |room|
        room.trombone {
          EM.stop
        }
      }
    }
  end

end
