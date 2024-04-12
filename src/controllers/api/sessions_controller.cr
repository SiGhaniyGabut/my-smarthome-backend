module Api
  class SessionsController < ApplicationController
    before_action { all { check_session_auth_credential! } }

    def detail
      response 200, session_auth
    end

    def validation
      user = User.find_by email: session_auth.email

      return response_error 404, "Your account is not registered yet!" unless user

      response 200, {message: "Credential checking passed..."}
    end

    def register
      return response_error 400, "Paremeters invalid. Check your request!" unless create_params.valid?

      user = User.new create_params.validate!
      return response_error 422, user.errors unless user.save

      response 201, user
    end

    private def check_session_auth_credential!
      session_auth
    rescue exception
      response_error 401, exception.message
    end

    private def create_params
      params.validation do
        required :name
        required :email
        required :uid
      end
    end
  end
end
