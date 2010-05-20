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

        if room.name =~ /test/
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
