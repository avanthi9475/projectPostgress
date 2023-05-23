class ApplicationController < ActionController::Base
    include Devise::Controllers::Helpers
    before_action :set_current_user

    def set_current_user
        if current_user_login &&  current_user_login.role=="user"
            Current.user = User.find_by(email: current_user_login.email)
        elsif current_user_login &&  current_user_login.role=="officer"
            Current.user = Officer.find_by(email: current_user_login.email)
        elsif current_user_login &&  current_user_login.role=="admin"
            Current.user = Head.find_by(email: current_user_login.email)
        end
    end    

    def redirect_user(msg)
        respond_to do |format|
            format.html { redirect_to Current.user, alert: msg }
        end
    end

end
