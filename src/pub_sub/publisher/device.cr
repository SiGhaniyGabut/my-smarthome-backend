module Publisher
  module Device
    def self.send_preparation_message(mac)
      send_by_mac mac, "preparation", {} of String => String
    end

    # Generic Device event
    def self.send_by_mac(mac, event, data)
      Connection::Publisher.publish "pubsub:device", {"mac" => mac, "event" => event, "data" => data}
    end

    def self.send(id, event, data)
      Connection::Publisher.publish "pubsub:device", {"device_id" => id, "event" => event, "data" => data}
    end
  end
end
