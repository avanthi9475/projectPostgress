class SignupsController < ApplicationController

    def index
    end

    def create
        user = Login.find_by(email: user_params[:email])
        if user && user.password == user_params[:password]
            session[:user_email] = user.email
            session[:user_role] = user.role
            set_current_user()
            if(user["role"] == "user")
                redirect_to user_path(Current.user.id)
            elsif(user["role"] == "admin")
                redirect_to admin_path(Current.user.id)
            elsif(user["role"] == "officer")
                redirect_to officer_path(Current.user.id)
            end
        else
            flash[:login_errors] = ["Invalid Credentials"]
            redirect_to '/signups'
        end
    end

    private
        def user_params
            params.require(:user).permit(:email, :password)
        end
end