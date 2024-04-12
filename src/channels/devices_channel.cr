class DevicesChannel < Amber::WebSockets::Channel
  include Helpers::WebSocket::Handler

  def handle_joined(client_socket, msg)
    DeviceHandler.new(client_socket, msg).authenticate!
  end

  def handle_message(client_socket, msg)
    DeviceHandler.handle_message client_socket, msg
  end

  def handle_leave(client_socket)
    DeviceHandler.handle_leave client_socket
  end
end
