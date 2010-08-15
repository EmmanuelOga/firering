module Firering
  class Connection
    include Firering::Requests

    attr_accessor :host
    attr_accessor :streaming_host
    attr_accessor :max_retries
    attr_accessor :retry_delay
    attr_accessor :redirects
    attr_accessor :logger
    attr_accessor :password
    attr_accessor :token
    attr_accessor :login

    def initialize(host, streaming_host = "https://streaming.campfirenow.com")
      @retry_delay, @redirects, @max_retries = 2, 1, 2
      self.host, self.streaming_host = host, streaming_host
      yield self if block_given?
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def host=(host)
      @host = Addressable::URI.parse(host)
    end

    def streaming_host=(host)
      @streaming_host = Addressable::URI.parse(host)
    end

    def auth_headers
      token ? {'authorization' => [token, "X"] } : {'authorization' => [login, password] }
    end

    def parameters(data = nil)
      parameters = {
        :redirects => redirects,
        :head => auth_headers.merge("Content-Type" => "application/json")
      }
      parameters.merge!(:body => data.is_a?(String) ? data : Yajl::Encoder.encode(data)) if data
      parameters
    end

    def http(method, path, data = nil, &callback)
      uri = host.join(path)
      logger.info("performing request to #{uri}")

      http = EventMachine::HttpRequest.new(uri).send(method, parameters(data))

      http.errback do
        perform_retry(http) do
          http(method, path, data, &callback)
        end
      end

      http.callback {
        @performed_retries = 0
        if callback
          data = Yajl::Parser.parse(http.response, :symbolize_keys => true) rescue Hash.new
          callback.call(data, http)
        end
      }

      http
    end

    # Streaming
    #
    # The Streaming API allows you to monitor a room in real time. The
    # authenticated user must already have joined the room in order to use this
    # API.
    def stream(room_id, &callback)
      parser = Yajl::Parser.new(:symbolize_keys => true)

      parser.on_parse_complete = proc do |data|
        callback.call(Firering::Message.instantiate(self, data)) if callback
      end

      uri = streaming_host.join("/room/#{room_id}/live.json")
      logger.info("performing streaming request to #{uri.to_s}")
      http = EventMachine::HttpRequest.new(uri).get(parameters)

      http.stream { |chunk| parser << chunk; @performed_retries= 0 }

      # Campfire servers will try to hold the streaming connections open indefinitely.
      # However, API clients must be able to handle occasional timeouts or
      # disruptions. Upon unexpected disconnection, API clients should wait for a
      # few seconds before trying to reconnect.  Formats
      http.errback do
        perform_retry(http) do
          stream(room_id, url, &callback)
        end
      end

      http
    end

    def perform_retry(http, &callback)
      if EventMachine.reactor_running? && (@performed_retries.nil? || @performed_retries < @max_retries)
        logger.error("http error #{http.error}. Trying again in #{retry_delay} seconds...")
        EventMachine::add_timer(retry_delay) do
          @performed_retries = (@performed_retries || 0) + 1
          logger.info("Reconnecting...")
          callback.call
        end
      else
        logger.error("The event machine loop is not running")
        raise Firering::Connection::HTTPError.new(http)
      end
    end

    class HTTPError < RuntimeError
      attr_reader :http
      def initialize(http)
        @http = http
      end
      def to_s
        "http error #{@http.error if @http.respond_to?(:error)}".strip
      end
    end

  end
end
