module Api
  class UsersController < ApplicationController
    def show
      response 200, current_user
    end

    def update
      return response_error 400, "Paremeters invalid. Check your request!" unless update_params.valid?

      return response_error 422, current_user.errors unless current_user.update update_params.validate!

      response 200, current_user
    end

    def destroy
      return response 422, current_user.errors unless current_user.destroy

      response 200, {message: "User deleted successfully!"}
    end

    private def update_params
      params.validation do
        optional :name
        optional :email
      end
    end
  end
end
