module Api
  module Concerns
    module Response
      def response(status : Int32, data)
        raise "Invalid status response for Success/Redirect" if status < 200 || status > 399
        response_payload status, data
      rescue exception
        response_error 500, exception.message
      end
  
      def response_error(status : Int32, message)
        raise "Invalid status response for Client/Server Errors" if status < 400 || status > 599
        response_payload status, {"message" => message}
      rescue exception
        response_error 500, exception.message
      end

      def response_payload(status : Int32, data)
        respond_with(status) { json({data: data, status: status}.to_json) }
      end
    end
  end
end
