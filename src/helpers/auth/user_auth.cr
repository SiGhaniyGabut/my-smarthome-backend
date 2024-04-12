module Helpers
  module Auth
    class UserAuth
      include JSON::Serializable

      @[JSON::Field(key: "name")]
      property name : String?

      @[JSON::Field(key: "picture")]
      property picture : String?

      @[JSON::Field(key: "email")]
      property email : String

      @[JSON::Field(key: "email_verified")]
      property email_verified : Bool

      @[JSON::Field(key: "user_id")]
      property user_id : String

      @[JSON::Field(key: "auth_time")]
      property auth_time : Int32

      def self.bearer_token(headers)
        authorization = headers["Authorization"]
        authorization.gsub /^Bearer /, "" if authorization && authorization.match /^Bearer /
      end

      def self.init(auth_payload)
        auth = UserAuth.from_json(auth_payload)
        new(auth.name, auth.picture, auth.email, auth.email_verified, auth.user_id, auth.auth_time)
      end

      def initialize(@name, @picture, @email, @email_verified, @user_id, @auth_time)
      end

      def authenticated?
        return true if user_authenticated?

        false
      end

      private def user_authenticated?
        return true if User.authenticated? email

        false
      end
    end
  end
end
