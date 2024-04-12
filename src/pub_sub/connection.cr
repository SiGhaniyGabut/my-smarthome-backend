module Connection
  module Publisher
    include Helpers::Redis::PubSub

    def self.publish(channel, message)
      connect.publish channel, message
    end

    private def self.connect
      # Do Stream Connection here...
      @@connect ||= Stream.connect
    end
  end

  module Subscriber
    include Helpers::Redis::PubSub
  
    def self.subscribe(channel, &block : Message -> _)
      connect.subscribe channel, &block
    end

    private def self.connect
      # Do Stream Connection here...
      @@connect ||= Stream.connect
    end
  end
end
