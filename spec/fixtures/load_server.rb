require 'open-uri'

class MyLogger < Logger
  alias write <<
end

class FixtureServer < Struct.new(:logger)

  def initialize(*args)
    super
    @fails = 0
  end

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    if adjusted_fails?(req)
      res.write("OK")
    else
      if @fails > 0
        log_hi("I was requested to fail, fails left: #{ @fails }")
        @fails -= 1
        res.write("")
        res.status = 404
      else
        log_hi("Trying to open fixture")
        res.write read_fixture(req)
      end
    end

    res.finish
  end

  def adjusted_fails?(req)
    if req.path =~ /fail\/(\d+)/
      log_hi("I was requested to fail next #{ @fails = $1.to_i } requests")
      true
    elsif req.path =~ /fail\/reset/
      @fails = 0
      log_hi("Fail count reset, next requests should not fail (unless a fixture is missing)")
      true
    else
      false
    end
  end

  def log(msg)
    logger.info("  FIXTURES: #{msg}")
  end

  def log_hi(msg)
    log("/" * 80) ; log(msg) ; log("/" * 80)
  end

  def read_fixture(req)
    return "It Works!" if req.path == "" || req.path == "/"

    path = fixture_path(req)

    if File.file?(path)
      log("Fixture found: #{path}")
      File.read(path).tap { |output| logger.info("\n\n#{output}\n") }
    else
      log("Fixture not found: #{path}")
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

def make_fixture_server_fail_times(times)
  open(URI("http://localhost:#{$specs_port}/fail/#{times}"))
end

def reset_fixture_server_fails
  make_fixture_server_fail_times("reset")
end
