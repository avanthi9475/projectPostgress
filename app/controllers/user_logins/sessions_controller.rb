class UserLogins::SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(resource)
        set_current_user()
        if resource.admin?
           head_path(Current.user.id)
        elsif resource.officer?
            @messages =  Current.user.request_messages.where("messages.created_at > ?", current_user_login.last_sign_in_at)
            @messages = @messages.select { |msg| msg.status.status == "Pending" }
            if(@messages.size>0)
                flash[:info] = "New Request Messages"
                officer_path(Current.user.id)
            else
                officer_path(Current.user.id)
            end
        else
            @messages = Current.user.response_messages.where("messages.created_at < ?", current_user_login.current_sign_in_at)
            @messages = @messages.select { |msg| msg.status.status == "Sent" }
            @messages.each do |message| 
                message.status.update(status: 'Received')
            end 

            if(@messages.size>0)
                flash[:info] = "You have received response from officers"
                user_path(Current.user.id)
            else
                user_path(Current.user.id)
            end
        end
    end
end
  