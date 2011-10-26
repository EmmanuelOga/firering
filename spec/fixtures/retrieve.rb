require 'rubygems'
require 'yajl'
require 'shellwords'
require 'fileutils'

HOST = "HOST"
TOKEN = "TOKEN"

Dir["{json,headers}/*"].each { |f| FileUtils.rm f }

def http(method, path, data = {})
  fixture = ([method.to_s] + path.split("/")).join("_").squeeze("_").gsub(/\d+/, "ID")

  if path =~ /^http/
    url = path
  else
    url = "http://#{HOST}.campfirenow.com#{path}"
  end

  data_param = "-d #{Yajl::Encoder.encode(data, :pretty => true).shellescape}" if data

  system("curl -X #{method.to_s.upcase} -u #{TOKEN}:X #{url} -N -H 'Content-Type: application/json' #{data_param} -D headers/#{fixture} #{url} > json/#{fixture}")
end

user_id = "415731"
room_id = "304355"
message_id = "224587793"

http :get,    "/rooms.json"
http :get,    "/room/#{room_id}.json"
http :put,    "/room/#{room_id}.json"
http :get,    "/room/#{room_id}/recent.json"
http :get,    "/room/#{room_id}/uploads.json"
http :get,    "/room/#{room_id}/transcript.json"
http :get,    "/room/#{room_id}/transcript/2010/05/28.json"

http :post,   "/room/#{room_id}/speak.json", :message => { :type => "TextMessage", :body => "Hello" }

#http :post,   "/room/#{room_id}/uploads.json"
#http :post,   "/room/#{room_id}/lock.json"

http :post,   "/room/#{room_id}/join.json"
http :post,   "/room/#{room_id}/leave.json"
http :post,   "/room/#{room_id}/unlock.json"

http :delete, "/messages/#{message_id}/star.json"
http :post,   "/messages/#{message_id}/star.json"

http :get,    "/users/#{user_id}.json"
http :get,    "/users/me.json"

http :get,    "/search/harmless.json"

http :post,   "/room/#{room_id}/join.json"
http :get,    "https://streaming.campfirenow.com/room/#{room_id}/live.json"
