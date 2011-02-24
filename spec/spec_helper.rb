$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'firering'
require 'rspec'
require 'rspec/autorun'
require 'fixtures/load_server'
require 'support/helpers'

RSpec.configure do |config|
  config.include Helpers

  config.before :all do
    $specs_logger = Logger.new(File.join(File.dirname(__FILE__), '..', 'log', "specs.log"))
    $pid = start_fixtures_server($specs_port = 8909)
  end

  config.after :all do
    Process.kill(:KILL, $pid) if $pid
  end
end
