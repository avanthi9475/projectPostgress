module Api
    class ApiController < ApplicationController

      respond_to :json
      skip_before_action :verify_authenticity_token
      # before_action :current_user
      # helper method to access the current user from the doorkeeper token

    #   def current_user
    #     # p doorkeeper_token
    #     @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id]) if doorkeeper_token
    #   end



    end
end