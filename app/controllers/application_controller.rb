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

    def check_for_messages
        if current_user_login.present?
            if current_user_login.role=="officer"
                @messages =  Current.user.request_messages.where("messages.created_at < ?", DateTime.now)
                @messages = @messages.select { |msg| msg.status.status == "Sent" }
                @messages.each do |message| 
                    message.status.update(status: 'Pending')
                end 
                if(@messages.size>0)
                    flash[:info] = "New Request Messages"
                end
            else
                @messages = Current.user.response_messages.where("messages.created_at < ?", DateTime.now)
                @messages = @messages.select { |msg| msg.status.status == "Sent" }
                @messages.each do |message| 
                    message.status.update(status: 'Received')
                end 
                if(@messages.size>0)
                    flash[:info] = "You have received response from officers"
                end
            end
        end
    end
end
