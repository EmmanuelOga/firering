require 'firering'

puts "If you prefer it, you can authenticate your user with u/p instead of the campfire token."

print "Enter subdomain: "
subdomain = gets.chomp

print "Enter user: "
user = gets.chomp

print "Enter password: "
password = gets.chomp

EM.run do
  Firering.authenticate(subdomain, user, password) do |user|

    puts "Token for user #{user.name} is #{user.token}"

    EM.stop

  end
end
