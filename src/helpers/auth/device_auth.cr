require "json"

module Helpers
  module Auth
    class DeviceAuth
      include JSON::Serializable
  
      @[JSON::Field(key: "topic")]
      property topic : String

      @[JSON::Field(key: "mac")]
      property mac : String
  
      @[JSON::Field(key: "api_key")]
      property api_key : String

      def self.init(auth_payload)
        auth = DeviceAuth.from_json(auth_payload)
        new auth.topic, auth.mac, auth.api_key
      end

      def initialize(@topic, @mac, @api_key)
      end

      def authenticated?
        return true if subtopic_and_mac_match? && user_authenticated? && device_registered_and_active?

        false
      end

      private def subtopic_and_mac_match?
        return true if topic.split(":").last == mac

        false
      end

      private def user_authenticated?
        return true if User.authenticated? Encryptor.decrypt api_key

        false
      end

      private def device_registered_and_active?
        return true if Device.registered_and_active? mac, api_key

        false
      end
    end
  end
end
