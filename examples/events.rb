require 'firering'

print "Enter subdomain: "; subdomain = gets.chomp
print "Enter user: "     ; login     = gets.chomp
print "Enter password: " ; password  = gets.chomp

conn = Firering::Connection.new("http://#{subdomain}.campfirenow.com") do |c|
  c.login = login
  c.password = password
end

EM.run do
  conn.authenticate do |user|
    conn.rooms do |rooms|
      rooms.each do |room|

        if room.name == "test2"
          room.stream do |message|
            case
            when message.advertisement?   then puts "Handle Ad"
            when message.allow_guests?    then puts "Handle Allow Guests"
            when message.disallow_guests? then puts "Handle Disallow Guests"
            when message.idle?            then puts "Handle Idle"
            when message.kick?            then puts "Handle Kick"
            when message.leave?           then puts "Handle Leave"
            when message.paste?           then puts "Handle Paste"
            when message.sound?           then puts "Handle Sound"
            when message.system?          then puts "Handle System"
            when message.text?            then puts "Handle Text"
            when message.timestamp?       then puts "Handle Timestamp"
            when message.topic_change?    then puts "Handle Topic Change"
            when message.unidle?          then puts "Handle Un Idle"
            when message.unlock?          then puts "Handle Unlock"
            when message.upload?          then puts "Handle Upload"
            end

            message.user do |user|
              puts "#{user}: #{message}"
            end
          end
        end

      end
    end
  end

  trap("INT") { EM.stop }
end
