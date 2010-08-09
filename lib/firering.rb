require 'eventmachine'
require 'yajl'
require 'em-http'
require 'date'

module Firering
  VERSION = '0.1.1'

  class Error < StandardError; end

  autoload :Data    , "firering/data"

  autoload :User    , "firering/data/user"
  autoload :Message , "firering/data/message"
  autoload :Room    , "firering/data/room"
  autoload :Upload  , "firering/data/upload"
end

require 'firering/http'
require 'firering/streaming'
require 'firering/requests'
