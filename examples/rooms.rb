require 'firering'

Firering.subdomain = ENV["CAMPFIRE_SUBDOMAIN"]
Firering.token     = ENV["CAMPFIRE_TOKEN"]

EM.run do
  Firering.rooms do |rooms|

    rooms.each do |room|
      puts "Users in room #{room.name}"

      if room.users.empty?
        puts "  empty (locked: #{room.locked?})"
      else
        room.users.each do |u|
          puts "  #{ u.name }"
        end
      end

    end
  end

  trap("INT") { EM.stop }
end
