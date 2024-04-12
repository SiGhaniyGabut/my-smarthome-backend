module Subscriber
  module Switch
    Connection::Subscriber.subscribe "pubsub:switch" do |message|
      on_update message.payload
    end

    def self.on_update(message)
      return unless message["event"] == "update"

      ::Switch.find(message["switch_id"]).not_nil!.update transform_data message["data"]
    end

    private def self.transform_data(data)
      data.as_h.transform_values &.as_s
    end
  end
end
