module Api
  class SwitchesController < ApplicationController
    include Helpers::WebSocket::Handler

    def index
      response 200, device.switches
    end

    def show
      switch = Switch.find_by device_id: device.id, id: params[:id]
      return response_error 404, "Switch not found" unless switch

      response 200, switch
    end

    def create
      return response_error 400, "Parameters invalid. Check your request" unless create_params.valid?

      switch = Switch.new create_params.validate!

      return response_error 422, switch.errors unless switch.save

      response 201, switch
    end

    def update
      return response_error 400, "Parameters invalid. Check your request" unless update_params.valid?

      switch = Switch.find_by device_id: device.id, id: params[:id]
      return response_error 404, "Switch not found" unless switch

      return response_error 422, switch.errors unless switch.update update_params.validate!

      if update_params.validate!.has_key? "state"
        DeviceHandler.send_message({
            "event"   => "message",
            "topic"   => switch.device_topic_channel,
            "subject" => "command",
            "payload" => Serializers::Switch.serialize switch
          })
      end

      response 200, switch
    end

    def destroy
      switch = Switch.find_by device_id: device.id, id: params[:id]
      return response_error 404, "Switch not found" unless switch

      return response_error 422, switch.errors unless switch.destroy

      response 200, {message: "Switch deleted successfully!"}
    end

    private def device
      Device.find_by(user_id: current_user.id, id: params[:device_id]).not_nil!
    end

    private def create_params
      params.validation do
        required :name
        required :pin
        required :pin_alias
        required :device_id
        optional :description
        optional :icon
        optional :mode
        optional :state
        optional :invert_state
        optional :active
      end
    end

    private def update_params
      params.validation do
        optional :name
        optional :pin
        optional :pin_alias
        optional :description
        optional :icon
        optional :mode
        optional :state
        optional :invert_state
        optional :active
      end
    end
  end
end
