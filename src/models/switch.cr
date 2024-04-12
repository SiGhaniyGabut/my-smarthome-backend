class Switch < Granite::Base
  connection pg
  table switches

  belongs_to :device

  validate_is_valid_choice :mode, ["OUT", "IN"]
  validate_is_valid_choice :state, [0, 1]

  before_create :generate_device_topic_channel
  before_update :shutdown_relay_on_deactivation

  column id                   : Int64, primary: true
  column name                 : String
  column description          : String?
  column icon                 : String?
  column pin                  : Int32
  column pin_alias            : String
  column mode                 : String = "OUT"
  column state                : Int32 = 0
  column invert_state         : Bool = false
  column active               : Bool = true
  column device_topic_channel : String
  timestamps

  private def generate_device_topic_channel
    self.device_topic_channel = device.topic_channel
  end

  private def shutdown_relay_on_deactivation
    return if active

    invert_state ? self.state = 1 : self.state = 0
  end
end
