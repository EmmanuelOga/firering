require 'firering'

Firering.subdomain = ENV["CAMPFIRE_SUBDOMAIN"]
Firering.token     = ENV["CAMPFIRE_TOKEN"]

EM.run do
  Firering.rooms do |rooms|
    rooms.each do |room|
      if room.name == "test2"
        Firering.room_join(room.id) do
          Firering.stream(room.id) do |message|

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

            puts message.to_s
          end
        end
      end
    end
  end

  trap("INT") { EM.stop }
end
