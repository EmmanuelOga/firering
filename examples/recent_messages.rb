$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))

require 'firering'

EM.run do
  Firering.authenticate("subdomain", "user", "password") do |user|
    Firering.rooms do |rooms|

      rooms.each do |room|
        puts "Users in room #{room.name} (#{room.topic})"

        if room.users.empty?
          puts "  empty"
        else
          room.users.each do |u|
            puts "  #{ u.name }. Admin: #{ user.admin? }"
          end
        end

        Firering.room_recent_messages(room.id) do |messages|
          puts messages
        end

      end
    end
  end

  trap("INT") { EM.stop }
end
