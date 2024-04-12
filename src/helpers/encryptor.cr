require "base64"

module Helpers
  class Encryptor
    include Amber::Support

    def self.encrypt(value : String) : Base64 | String
      Base64.encode(String.new(MessageEncryptor.new(Amber.settings.secret_key_base).encrypt_and_sign(value))).gsub "\n", ""
    end

    def self.decrypt(value : Base64 | String) : String
      String.new(MessageEncryptor.new(Amber.settings.secret_key_base).verify_and_decrypt(Base64.decode(value)))
    end
  end
end
