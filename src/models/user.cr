class User < Granite::Base
  connection pg
  table users

  has_many :devices, class_name: "Device"
  has_many :api_keys, class_name: "ApiKey"

  validate_not_nil :name
  validate_not_nil :email
  validate_not_nil :uid

  validate :email, "must be in valid email format!" { |user| email_valid?(user.email.not_nil!) }

  column id     : Int64, primary: true
  column name   : String
  column email  : String, unique: true
  column uid    : String, unique: true
  timestamps

  def self.authenticated?(email : String) : Bool
    return true if User.find_by(email: email)

    false
  end

  private def self.email_valid?(email : String) : Bool
    return true if email =~ /^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/

    false
  end
end
