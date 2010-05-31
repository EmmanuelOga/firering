require 'open-uri'

server_file = File.join(File.dirname(__FILE__), 'server.rb')

port = 4567

pid = fork do
  exec("`which ruby` #{server_file}")
end

start = Time.now
spawned = false

while Time.now - start < 5
  begin
    open(URI("http://localhost:#{port}/"))
  rescue Errno::ECONNREFUSED
    sleep 1
  rescue OpenURI::HTTPError
    spawned = true
    break
  end
end

unless spawned
  raise "Could not run the fixtures server"
end

at_exit do
  Process.kill(:KILL, pid) if pid
end
