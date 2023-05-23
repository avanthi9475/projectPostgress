module Api
  class ApiController < ApplicationController

    respond_to :json
    before_action :doorkeeper_authorize!
    skip_before_action :verify_authenticity_token

    # before_action :current_user
    # helper method to access the current user from the doorkeeper

    # def current_user
    #   # p doorkeeper_token
    #   @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id]) if doorkeeper_token

    private def current_user
        @current_user ||= UserLogin.find_by(id: doorkeeper_token[:resource_owner_id])
    end
    
    private def current_userlogin
      if @current_user.role=='user'
        @current_userlogin ||= User.find_by(email: @current_user.email)
      else
        @current_userlogin ||= Officer.find_by(email: @current_user.email)
      end
    end

  end
end