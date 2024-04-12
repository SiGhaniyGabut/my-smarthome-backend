require "./authentication"
require "./response"

module Api
  module Concerns
    include Authentication
    include Response
  end
end
