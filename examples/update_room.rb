require 'firering'

Firering.subdomain = ENV["CAMPFIRE_SUBDOMAIN"]
Firering.token     = ENV["CAMPFIRE_TOKEN"]

ROOM = "test2"

EM.run do
  Firering.rooms do |rooms|
    rooms.each do |room|
      if room.name == ROOM
        Firering.room_join(room.id) do

          Firering.update_room(room.id, "topic" => "test test test") do |response|
            puts "  * Updating topic: "
            puts response.response_header.status
          end

          Firering.text(room.id, "hola") do
            puts "texted"
          end

          Firering.paste(room.id, "hola\nmundo") do
            puts "pasted"
          end

        end
      end
    end
  end

  trap("INT") { EM.stop }
end
