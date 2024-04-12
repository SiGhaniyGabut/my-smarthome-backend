require "./context"

module Jobs
  class DevicePreparation
    include Sidekiq::Worker

    def perform(mac : String)
      Publisher::Device.send_preparation_message mac
    end
  end
end
