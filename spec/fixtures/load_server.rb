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

    path = fixture_path(req)

    if File.file?(path)
      logger.info("Opening fixture: #{path}")
      File.read(path).tap { |output| logger.info("\n\n#{output}\n") }
    else
      logger.info("Fixture not found: #{path}")
      "FIXTURE NOT FOUND #{path}"
    end
  end

  def fixture_path(req)
    name_parts = [req.request_method.to_s.downcase] + req.path.split("/")
    name = name_parts.join("_").squeeze("_").gsub(/\d+/, "ID")
    File.expand_path(File.join(File.dirname(__FILE__), "json", name))
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
