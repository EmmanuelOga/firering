module Firering
  module HTTP

    HOST = "campfirenow.com"

    # helper to perform an http request following redirects
    def http(method, path, data = nil, user = Firering.token, password = "X", &block)
      url = (path =~ /^http/) ? path : "http://#{Firering.subdomain}.#{HOST}#{path}"

      parameters = { :head => {'authorization' => [user, password], "Content-Type" => "application/json" } }
      parameters.merge!(:body => data.is_a?(String) ? data : Yajl::Encoder.encode(data)) if data

      http = EventMachine::HttpRequest.new(url).send method, parameters

      http.errback do
        raise Firering::Error, "#{http.errors}\n#{url}, #{method}, #{parameters.inspect}\n#{http.response_header.status}\n#{http.response}"
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
