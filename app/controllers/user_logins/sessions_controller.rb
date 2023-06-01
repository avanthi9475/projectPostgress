class UserLogins::SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(resource)
        set_current_user()
        if resource.admin?
           head_path(Current.user.id)
        elsif resource.officer?
            officer_path(Current.user.id)
        else
            user_path(Current.user.id)
        end
    end
    
end
  