require "json"

module Helpers
  module Redis
    module PubSub
      class Stream
        getter connection : Connection
  
        def initialize(@connection = Connection.new)
        end
  
        def self.connect
          @@connect ||= new
        end
  
        def self.connect(connection : Connection)
          @@connect ||= new connection
        end
  
        def publish(channel : String, payload)
          connection.redis do |redis|
            redis.publish channel, Message.new(payload).to_json
          end
        end
  
        def subscribe(channel : String, &block : Message ->)
          spawn do
            connection.redis do |redis|
              redis.subscribe(channel) { |on| on.message { |_channel, payload| block.call Message.from_json payload } }
            end
          end
        end
      end
    end
  end
end
