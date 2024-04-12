module Api
  module Concerns
    module Authentication
      include Helpers::Auth

      def session_auth
        @session_auth ||= UserAuth.init decoded_token.payload.to_json
      end

      def current_user
        User.find_by(uid: session_auth.user_id).not_nil!
      end

      def decoded_token
        Firebase::Token.decode_and_verify bearer_token.not_nil!
      rescue exception
        raise exception.message.not_nil!
      end
  
      def bearer_token
        UserAuth.bearer_token request.headers
      rescue
        raise "Missing authorization header!"
      end
    end
  end
end
