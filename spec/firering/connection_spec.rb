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

  it "performs connection retries if the connection drops" do
    conn.retry_delay = 1
    make_fixture_server_fail_times(conn.max_retries)
    messages = []

    EM.run {
      conn.stream(304355) do |message|
        messages << message
      end
      EM.add_timer(conn.max_retries * conn.retry_delay + 1) do
        EM.stop
      end
    }

    messages.should_not be_empty
  end

  it "raises an exception if the connection drops and performed enough retries" do
    conn.retry_delay = 1
    make_fixture_server_fail_times(conn.max_retries + 1)
    messages = []

    begin
      EM.run {
        conn.stream(304355) { |message| messages << message }

        EM.add_timer(conn.max_retries * conn.retry_delay + 1) { EM.stop }
      }
    rescue Firering::Connection::HTTPError
    ensure
      EM.stop if EventMachine.reactor_running?
    end

    messages.should be_empty
  end
end
