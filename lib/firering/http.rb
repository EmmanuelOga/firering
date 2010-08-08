module Firering
  module HTTP
    extend self

    attr_accessor :host, :retry_delay

    HTTP.host = "campfirenow.com"
    HTTP.retry_delay = 2

    # helper to perform an http request following redirects
    def http(method, path, data = nil, user = Firering.token, password = "X", &block)

      if (path =~ /^http/)
        url = path
      else
        # handle nil subdomain for testing (e.g a fake localhost campfire server)
        url = "http://#{[Firering.subdomain, host].compact.join(".")}#{path}"
      end

      parameters = { :head => {'authorization' => [user, password], "Content-Type" => "application/json" } }
      parameters.merge!(:body => data.is_a?(String) ? data : Yajl::Encoder.encode(data)) if data

      http = EventMachine::HttpRequest.new(url).send method, parameters

      http.errback do
        if EventMachine.reactor_running?
          puts "Error: #{http.errors}. Trying again in #{retry_delay} seconds..."

          EventMachine::add_timer(retry_delay) do
            puts "reconnecting"
            stream(room_id, url, &block)
          end
        else
          raise Firering::Error, "#{http.errors}\n#{url}, #{method}, #{parameters.inspect}\n#{http.response_header.status}\n#{http.response}"
        end
      end

      http.callback do
        case http.response_header.status.to_s
        when /^2../
          block.call(http)
        when "302"
          http(method, http.response_header["Location"], user, password, &block) # follow redirects
        else
          raise Firering::Error, "#{http.errors}\n#{url}, #{method}, #{parameters.inspect}\n#{http.response_header.status}\n#{http.response}"
        end
      end

      http
    end

  end
end
