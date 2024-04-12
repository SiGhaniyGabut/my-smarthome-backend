struct DevicesSocket < Amber::WebSockets::ClientSocket
  channel "devices:*", DevicesChannel

  def on_connect
    true
  end

  def self.disconnect!(socket)
    socket.disconnect!
  end
end
