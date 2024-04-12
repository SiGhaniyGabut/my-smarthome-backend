module Api
  class KeysController < ApplicationController
    def show
      api_key = ApiKey.find_by user_id: current_user.id, device_id: params[:device_id]
      return response_error 404, "API Key not found" unless api_key

      response 200, api_key
    end

    def create
      return response_error 400, "Parameters invalid. Check your request" unless create_params.valid?

      api_key = ApiKey.new create_params.validate!
      api_key.user_id = current_user.id

      return response_error 422, api_key.errors unless api_key.save

      response 201, api_key
    end

    def destroy
      api_key = ApiKey.find_by user_id: current_user.id, device_id: params[:device_id]
      return response_error 404, "API Key not found" unless api_key

      return response_error 422, api_key.errors unless api_key.destroy

      response 200, {message: "API Key deleted successfully"}
    end

    private def create_params
      params.validation do
        required :device_id
      end
    end
  end
end
