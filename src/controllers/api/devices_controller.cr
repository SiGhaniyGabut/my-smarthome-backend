module Api
  class DevicesController < ApplicationController
    def index
      response 200, current_user.devices
    end

    def show
      device = Device.find_by id: params[:id], user_id: current_user.id
      return response_error 404, "Device not found" unless device

      response 200, device
    end

    def create
      return response_error 400, "Parameters invalid. Check your request" unless create_params.valid?

      device = Device.new create_params.validate!
      device.user_id = current_user.id

      return response_error 422, device.errors unless device.save

      response 201, device
    end

    def update
      return response_error 400, "Parameters invalid. Check your request" unless update_params.valid?

      device = Device.find_by id: params[:id], user_id: current_user.id
      return response_error 404, "Device not found" unless device

      return response_error 422, device.errors unless device.update update_params.validate!

      response 200, device
    end

    def destroy
      device = Device.find_by id: params[:id], user_id: current_user.id
      return response_error 404, "Device not found" unless device

      return response_error 422, device.errors unless device.destroy

      response 200, {message: "Device deleted successfully!"}
    end

    def restart
      device = Device.find_by id: params[:device_id], user_id: current_user.id
      return response_error 404, "Device not found" unless device

      device.send_restart_message

      response 200, {message: "Device restarted successfully!"}
    end

    private def create_params
      params.validation do
        required :name
        required :mac
        optional :active
      end
    end

    private def update_params
      params.validation do
        optional :name
        optional :mac
        optional :active
      end
    end
  end
end
