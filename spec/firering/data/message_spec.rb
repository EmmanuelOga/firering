require 'spec_helper'

describe Firering::Message do

  it "gets a collection of recent messages" do
    EM.run {
      conn.room(304355) do |room|
        room.recent_messages do |messages|

          messages.each do |m|
            m.should be_an_instance_of(Firering::Message)
          end

          message = messages.first
          message.should be_timestamp
          message.room_id.should == 304355
          message.created_at.should == Time.parse("2010/05/29 22:05:00 +0000")
          message.body.should be_nil
          message.id.should == 224587718
          message.user_id.should be_nil

          EM.stop

        end
      end
    }
  end

  it "returns a collection of messages matching certain pattern" do
    EM.run {
      conn.search_messages("harmless") do |messages|
        messages.length.should == 3

        messages.each do |m|
          m.should be_an_instance_of(Firering::Message)
        end

        message = messages.last
        message.should be_text
        message.room_id.should == 177718
        message.created_at.should == Time.parse("2009/06/02 21:20:32 +0000")
        message.body.should == "q: should i add :case_sensitive =\u003E false to the validation of title name? Looks harmless but who knows..."
        message.id.should == 134405854
        message.user_id.should == 415731

        EM.stop
      end
    }
  end

  it "is able to star / un-star a message" do
    EM.run {
      conn.star_message(224590113) {
        conn.star_message(224590113, false) {
          EM.stop
        }
      }
    }
  end

end
