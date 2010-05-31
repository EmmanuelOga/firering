require 'firering'

Firering.subdomain = ENV["CAMPFIRE_SUBDOMAIN"]
Firering.token     = ENV["CAMPFIRE_TOKEN"]

EM.run do
  Firering.rooms do |rooms|

    rooms.each do |room|
      puts "Users in room #{room.name} (#{room.topic})"

      if room.users.empty?
        puts "  empty (locked: #{room.locked?})"
      else
        room.users.each do |u|
          puts "  #{ u.name }. Admin: #{ u.admin? }"
        end
      end

      if room.locked?
        puts "  can't get recent messages in a locked room'"
      else
        Firering.room_recent_messages(room.id) do |messages|

          puts "-" * 80
          puts "recent message on #{room.name}"
          puts "-" * 80

          messages.slice(0, 4).each do |m|
            puts "\n  (#{m.user_id})"

            m.body.to_s.split("\n").each do |chunk|
              puts "  > #{chunk}"
            end
          end
        end
      end

    end
  end

  trap("INT") { EM.stop }
end
