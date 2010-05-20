$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))

require 'firering'

$count = 0

EM.run do
  Firering.authenticate("subdomain", "user", "password") do |user|

    Firering.rooms do |rooms|

      $count = rooms.length

      rooms.each do |room|
        $count -= 1

        puts "Users in room #{room.name}"

        if room.users.empty?
          puts "  empty"
        else
          room.users.each do |u|
            puts "  #{ u.name }"
          end
        end

        EM.stop if $count == 0
      end
    end
  end
end
