require 'firering'

print "Enter subdomain: "; subdomain = gets.chomp
print "Enter user: "     ; login     = gets.chomp
print "Enter password: " ; password  = gets.chomp

conn = Firering::Connection.new("http://#{subdomain}.campfirenow.com") do |c|
  c.login = login
  c.password = password
end

EM.run do
  conn.authenticate do
    conn.rooms do |rooms|

      rooms.each do |room|
        puts "Users in room #{room.name} (#{room.topic})"

        room.users do |users|
          if users.empty?
            puts "  empty (locked: #{room.locked?})"
          else
            users.each do |u|
              puts "  #{ u.name }. Admin: #{ u.admin? }"
            end
          end
        end

        if room.locked?
          puts "  can't get recent messages in a locked room'"
        else
          room.recent_messages do |messages|

            puts "-" * 80
            puts "recent message on #{room.name}"
            puts "-" * 80

            messages.slice(0, 4).each do |m|
              m.user do |u|
                puts "\n  (#{u})"

                m.body.to_s.split("\n").each do |chunk|
                  puts "  > #{chunk}"
                end
              end
            end
          end
        end

      end
    end
  end

  trap("INT") { EM.stop }
end
