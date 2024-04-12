module Publisher
  module Switch
    def self.set_status(id, status)
      send id, "update", {"status" => status}
    end

    # Generic Switch event
    def self.send(id, event, data)
      PubSub.publish "pubsub:switch", {"switch_id" => id, "event" => event, "data" => data}
    end
  end
end
