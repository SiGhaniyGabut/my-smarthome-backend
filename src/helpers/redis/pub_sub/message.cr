require "uuid"
require "json"

module Helpers
  module Redis
    module PubSub
      struct Message
        include JSON::Serializable
  
        getter uuid : String
        getter timestamp : Time
        getter payload : JSON::Any
  
        def initialize(payload, @uuid = UUID.random.to_s, @timestamp = Time.utc)
          @payload = JSON.parse payload.to_json
        end
      end
    end
  end
end
