require "json"

module Helpers
  module WebSocket
    struct Body
      include JSON::Serializable
  
      @[JSON::Field(key: "event")]
      property event : String
  
      @[JSON::Field(key: "topic")]
      property topic : String
  
      @[JSON::Field(key: "subject")]
      property subject : String
  
      @[JSON::Field(key: "payload")]
      property payload : Hash(String, JSON::Any)
  
      def self.create(message)
        Body.from_json %(#{message.to_json})
      end
    end
  end
end
