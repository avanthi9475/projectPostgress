# app/controllers/registrations_controller.rb
class UserLogins::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    end

    protected

    def after_sign_up_path_for(resource)
        @user = User.new(user_params)
        if @user.save
            set_current_user()
            user_path(Current.user.id)
        end
    end

    def after_sign_out_path_for(resource_or_scope)
        new_user_session_path
    end

    private
        def user_params
            params.require(:user_login).permit(:email, :name, :age, :location, :noOfComplaintsMade)
        end
end
  