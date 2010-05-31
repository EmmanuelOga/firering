require 'rack'
require 'thin'
require 'sinatra'

use Rack::ContentLength

def setup(method, path)
  fixture = ([method.to_s] + path.split("/")).join("_").squeeze("_").gsub("*", "ID")

  send(method, path) do
    File.read(File.expand_path(File.join(File.dirname(__FILE__), "json", fixture)))
  end
end

setup :get,    "/rooms.json"

setup :get,    "/room/*/recent.json"
setup :get,    "/room/*/uploads.json"
setup :get,    "/room/*/transcript.json"
setup :get,    "/room/*/transcript/2010/05/28.json"
setup :post,   "/room/*/speak.json"
setup :post,   "/room/*/uploads.json"
setup :post,   "/room/*/lock.json"
setup :post,   "/room/*/join.json"
setup :post,   "/room/*/leave.json"
setup :post,   "/room/*/unlock.json"

setup :delete, "/messages/*/star.json"
setup :post,   "/messages/*/star.json"

setup :get,    "/users/me.json"
setup :get,    "/users/*.json"

setup :get,    "/search/harmless.json"

setup :post,   "/room/*/join.json"
setup :get,    "/room/*/live.json"

setup :get,    "/room/*.json"
setup :put,    "/room/*.json"
