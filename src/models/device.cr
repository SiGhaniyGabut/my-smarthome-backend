require "uuid"
require "../pub_sub/subscriber/device"

class Device < Granite::Base
  include Helpers::WebSocket::Handler
  include Subscriber::Device

  connection pg
  table devices

  has_one :api_key
  has_many :switches, class_name: Switch
  belongs_to :user

  validate_not_nil :name
  validate_not_nil :mac
  validate_not_nil :user_id

  validate :mac, "must be in upcase, split by -, and valid mac character" { |device| mac_valid? device.mac.not_nil! }

  before_create :generate_uuid
  before_save :generate_topic_channel

  column id             : Int64, primary: true
  column name           : String
  column uuid           : String, unique: true
  column mac            : String, unique: true
  column active         : Bool = true
  column topic_channel  : String
  timestamps

  def self.registered_and_active?(mac : String, api_key : String) : Bool
    device = Device.find_by mac: mac

    return true unless device.nil? || device.active == false || ApiKey.find_by(key: api_key, device_id: device.id).nil?

    false
  end

  def active_switches
    switches.select { |switch| switch.active }
  end

  private def generate_uuid
    self.uuid = UUID.random.to_s
  end

  private def generate_topic_channel
    self.topic_channel = "devices:#{self.mac}"
  end

  private def self.mac_valid?(mac : String) : Bool
    return true if mac =~ /^[0-9A-F]{2}(-[0-9A-F]{2}){5}$/

    false
  end

  def send_auth_message
    DeviceHandler.send_message({
      "event": "message",
      "topic": topic_channel,
      "subject": "joined",
      "payload": { "status": "success", "message": "Your device has been authenticated and established to the server." }
    })
  end

  def send_setup_message
    DeviceHandler.send_message({
      "event": "message",
      "topic": topic_channel,
      "subject": "setup",
      "payload": { "switches": Serializers::Switch.serialize switches }
    })
  end

  def send_restart_message
    DeviceHandler.send_message({
      "event": "message",
      "topic": topic_channel,
      "subject": "restart",
      "payload": { "status": "success", "message": "Restart message has been sent to your device." }
    })
  end
end
