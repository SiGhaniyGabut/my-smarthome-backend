module Subscriber
  module Device
    Connection::Subscriber.subscribe "pubsub:device" do |message|
      on_preparation message.payload
    end

    def self.on_preparation(message)
      return unless message["event"] == "preparation"

      device = ::Device.find_by mac: message["mac"].to_s
      return if device.nil?

      device.send_auth_message
      device.send_setup_message
    end

    private def self.transform_data(data)
      data.as_h.transform_values &.as_s
    end
  end
end
