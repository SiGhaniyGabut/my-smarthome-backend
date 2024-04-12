require "jasper_helpers"
require "./concerns"

module Api
  # This class is base class for all API controllers
  class ApplicationController < Amber::Controller::Base
    include JasperHelpers
    include Concerns

    before_action { all { authenticate_user! } }

    private def authenticate_user!
      return if self.class == SessionsController

      begin
        response_error 403, "Your credential not enough to fulfill this request!" unless session_auth.authenticated?
      rescue exception
        response_error 401, exception.message
      end
    end
  end
end
