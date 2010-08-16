require 'firering'

conn = Firering::Connection.new("http://#{ENV["CAMPFIRE_SUBDOMAIN"]}.campfirenow.com") do |c|
  c.token = ENV["CAMPFIRE_TOKEN"]
end

EM.run do
  conn.rooms do |rooms|
    rooms.each do |room|

      room.users do |users|
        puts "Users in room #{room.name}"

        if users.empty?
          puts "  empty (locked: #{room.locked?})"
        else
          users.each do |u|
            puts "  #{ u.name }"
          end
        end

        puts
      end

    end
  end

  trap("INT") { EM.stop }
end
