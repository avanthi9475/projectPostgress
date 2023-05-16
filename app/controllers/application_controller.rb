class ApplicationController < ActionController::Base
    include Devise::Controllers::Helpers
    before_action :set_current_user

    def set_current_user
        if current_user_login &&  current_user_login.role=="user"
            Current.user = User.find_by(email: current_user_login.email)
        elsif current_user_login &&  current_user_login.role=="officer"
            Current.user = Officer.find_by(email: current_user_login.email)
        elsif current_user_login &&  current_user_login.role=="admin"
            Current.user = Admin.find_by(email: current_user_login.email)
        end
    end

    protected

    def after_sign_in_path_for(resource)
        set_current_user()
        if resource.admin?
           admin_path(Current.user.id)
        elsif resource.officer?
            @messages =  Current.user.officer_messages.where(message_type: 'User').where("messages.created_at > ?", current_user_login.last_sign_in_at)
            @messages = @messages.select { |msg| msg.status.status == "Pending" }
            if(@messages.size>0)
                flash[:info] = "New Request Messages"
                officer_path(Current.user.id)
            else
                officer_path(Current.user.id)
            end
        else
            @messages = Current.user.user_messages.where(message_type: "Officer").where("messages.created_at > ?", current_user_login.last_sign_in_at)
            if(@messages.size>0)
                flash[:info] = "You have received response from officers"
                user_path(Current.user.id)
            else
                user_path(Current.user.id)
            end
        end
    end

    

end
