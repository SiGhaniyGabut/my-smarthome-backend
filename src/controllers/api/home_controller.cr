module Api
  class HomeController < ApplicationController
    def index
      response 200, {message: "Welcome to My SmartHome API"}
    end
  end
end
