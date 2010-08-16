require 'firering'

puts "If you prefer it, you can authenticate your user with u/p instead of the campfire token."

print "Enter subdomain: "; subdomain = gets.chomp
print "Enter user: "     ; login     = gets.chomp
print "Enter password: " ; password  = gets.chomp

conn = Firering::Connection.new("http://#{subdomain}.campfirenow.com") do |c|
  c.login = login
  c.password = password
end

EM.run do
  conn.authenticate do |user|

    puts "Token for user #{user.name} is #{user.token}"
    puts "You can set an environment variable for using it on scripts:"
    puts "export CAMPFIRE_TOKEN=#{user.token}"

    EM.stop

  end
end
