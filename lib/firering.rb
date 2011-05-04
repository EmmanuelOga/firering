require 'logger'
require 'date'
require 'eventmachine'
require 'yajl'
require 'em-http'

module Firering
  VERSION = '1.1.0'

  Error = Class.new(StandardError)

  autoload :Requests     , "firering/requests"
  autoload :Connection   , "firering/connection"

  autoload :Instantiator , "firering/instantiator"
  autoload :User         , "firering/data/user"
  autoload :Message      , "firering/data/message"
  autoload :Room         , "firering/data/room"
  autoload :Upload       , "firering/data/upload"
end
