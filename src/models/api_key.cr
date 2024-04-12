class ApiKey < Granite::Base
  connection pg
  table api_keys
  
  belongs_to :user
  belongs_to :device

  validate_not_nil :user_id
  validate_not_nil :device_id

  before_create :set_name, :generate_api_key, :destroy_old_keys

  column id   : Int64, primary: true
  column name : String
  column key  : String
  timestamps

  private def set_name
    self.name = "API Key for #{device.name}"
  end

  private def generate_api_key
    self.key = Helpers::Encryptor.encrypt user.email
  end

  private def destroy_old_keys
    ApiKey.where(user_id: user_id, device_id: device_id).delete
  end
end
