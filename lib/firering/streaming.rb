module Firering
  module Streaming
    extend self

    attr_accessor :protocol, :host, :reconnect_delay

    Streaming.host = "streaming.campfirenow.com"
    Streaming.protocol = "https"
    Streaming.reconnect_delay = 5

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

      url ||= "#{Streaming.protocol}://#{Streaming.host}/room/#{room_id}/live.json"

      params = { :head => {'authorization' => [Firering.token, "X"], "Content-Type" => "application/json" } }

      http = EventMachine::HttpRequest.new(url).get(params)

      http.stream { |chunk| parser << chunk }

      # campfire servers will try to hold the streaming connections open indefinitely.
      # However, API clients must be able to handle occasional timeouts or
      # disruptions. Upon unexpected disconnection, API clients should wait for a
      # few seconds before trying to reconnect.  Formats
      http.errback do
        if EventMachine.reactor_running?
          puts "Error: #{http.errors}. Reconnecting in #{Streaming.reconnect_delay} seconds..."

          EventMachine::add_timer(Streaming.reconnect_delay) do
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

