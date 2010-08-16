require 'firering'

conn = Firering::Connection.new("http://#{ENV["CAMPFIRE_SUBDOMAIN"]}.campfirenow.com") do |c|
  c.token = ENV["CAMPFIRE_TOKEN"]
end

ROOM = "test2"

EM.run do
  conn.rooms do |rooms|
    rooms.each do |room|

      if room.name == ROOM
        room.join do

          room.update("topic" => "test test test") do |data, http|
            print "  * Updating topic. HTTP Status returned: "
            puts http.response_header.status
          end

          room.text("this is a test from the refactored gem") do
            puts "sent text"
          end

          room.paste("this is a\npaste\nfrom the refactored gem") do
            puts "sent paste"
          end

        end
      end

    end
  end

  trap("INT") { EM.stop }
end
