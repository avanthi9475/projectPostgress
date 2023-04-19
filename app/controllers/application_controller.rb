class ApplicationController < ActionController::Base
    before_action :set_current_user

    def set_current_user
        if session[:user_email] && session[:user_role]=="user"
            Current.user = User.find_by(email: session[:user_email])
        elsif session[:user_email] && session[:user_role]=="officer"
            Current.user = Officer.find_by(email: session[:user_email])
        elsif session[:user_email] && session[:user_role]=="admin"
            Current.user = Admin.find_by(email: session[:user_email])
        end
    end

end
