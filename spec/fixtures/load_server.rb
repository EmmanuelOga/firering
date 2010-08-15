require 'open-uri'

class MyLogger < Logger
  alias write <<
end

class FixtureServer < Struct.new(:logger)
  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    res.write read_fixture(req)
    res.finish
  end

  def read_fixture(req)
    return "It Works!" if req.path == "" || req.path == "/"
    fixture = ([req.request_method.to_s.downcase] + req.path.split("/")).join("_").squeeze("_").gsub(/\d+/, "ID")
    path = File.expand_path(File.join(File.dirname(__FILE__), "json", fixture))
    logger.info("opening fixture: #{path}, #{File.file?(path)}")
    output = File.file?(path) ? File.read(path) : "FIXTURE NOT FOUND #{path}"
    logger.info("\n\n#{output}\n")
    output
  end
end

def start_fixtures_server(port)
  pid = fork do
    require 'rack'
    require 'logger'

    $stdout = $stderr = File.open("/dev/null", "w")

    logger = MyLogger.new(File.join(File.dirname(__FILE__), '..', '..', 'log', "specs.log"))
    logger.info("\n#{'-'*80}\n")

    app = FixtureServer.new(logger)
    app = Rack::ShowStatus.new(Rack::ShowExceptions.new(app))
    app = Rack::CommonLogger.new(app, logger)

    Rack::Handler::WEBrick.run app, :Port => $specs_port
  end

  spawned, start = false, Time.now

  while Time.now - start < 5
    begin
      open(URI("http://localhost:#{$specs_port}/"))
    rescue
      sleep 1
    else
      break spawned = true
    end
  end

  raise "Could not run the fixtures server" unless spawned

  pid
end
