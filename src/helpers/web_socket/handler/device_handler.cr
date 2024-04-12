module Helpers
  module WebSocket
    module Handler
      class DeviceHandler
        getter device : Auth::DeviceAuth

        def initialize(@socket : DevicesSocket, @message : JSON::Any)
          @device = DeviceHandler.device_auth message
        end

        def authenticate!
          DeviceHandler.handle_leave @socket unless @device.authenticated?

          Jobs::DevicePreparation.async.perform @device.mac
        end

        def self.handle_message(socket, message)
          return unless device_auth(message).authenticated?
        end

        def self.send_message(message)
          message = Body.create message
          DevicesSocket.broadcast message.event, message.topic, message.subject, message.payload
        end

        def self.handle_leave(socket)
          DevicesSocket.disconnect! socket
        end

        def self.device_auth(message)
          Auth::DeviceAuth.init auth_payload Body.create message
        end

        def self.auth_payload(message : Body)
          {"topic" => message.topic}.merge(message.payload.not_nil!).to_json
        end
      end
    end
  end
end
