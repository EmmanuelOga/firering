module Firering

  # {"room_id":1,"created_at":"2009-12-01 23:44:40","body":"hello","id":1,
  # "user_id":1,"type":"TextMessage"} {"room_id":1,"created_at":"2009-12-01
  # 23:40:00","body":null,"id":2, "user_id":null,"type":"TimestampMessage"}
  # ...
  module Streaming

    STREAMING_HOST = "streaming.campfirenow.com"

    RECONNECT_TIMEOUT = 5

    # Streaming
    #
    # The Streaming API allows you to monitor a room in real time. The
    # authenticated user must already have joined the room in order to use this
    # API.
    def stream(room_id, url = nil, &block)
      parser = Yajl::Parser.new(:symbolize_keys => true)
      parser.on_parse_complete = proc do |hash|
        block.call(Firering::Message.new(hash))
      end

      url ||= "https://#{STREAMING_HOST}/room/#{room_id}/live.json"

      params = { :head => {'authorization' => [Firering.token, "X"], "Content-Type" => "application/json" } }

      http = EventMachine::HttpRequest.new(url).get(params)

      http.stream { |chunk| parser << chunk }

      # campfire servers will try to hold the streaming connections open indefinitely.
      # However, API clients must be able to handle occasional timeouts or
      # disruptions. Upon unexpected disconnection, API clients should wait for a
      # few seconds before trying to reconnect.  Formats
      http.errback do
        if EventMachine.reactor_running?
          puts "Error: #{http.errors}. Reconnecting in #{RECONNECT_TIMEOUT} seconds..."

          EventMachine::add_timer(RECONNECT_TIMEOUT) do
            puts "reconnecting"
            stream(room_id, url, &block)
          end
        else
          puts "EventMachine loop stopped."
        end
      end
    end

  end
end

