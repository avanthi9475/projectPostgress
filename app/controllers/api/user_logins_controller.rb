module Api
    class UserLoginsController < Api::ApplicationController
        skip_before_action :doorkeeper_authorize!, only: [:create]
        def create
            @user=UserLogin.new(email: user_params[:email], password: user_params[:password], role: user_params[:role])
            client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
            return render(json: 'Invalid client ID' , status: 403 ) unless client_app
            #return render(json: { error: 'Invalid client ID'}, status: 403) unless client_app

            
            if @user.save
                access_token = Doorkeeper::AccessToken.create(
                                resource_owner_id: @user.id,
                                application_id: client_app.id,
                                refresh_token: generate_refresh_token,
                                expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
                                scopes: ''
                                )
                render(json: {
                        user: {
                        id: @user.id,
                        email: @user.email,
                        access_token: access_token.token,
                        token_type: 'bearer',
                        expires_in: access_token.expires_in,
                        refresh_token: access_token.refresh_token,
                        created_at: access_token.created_at.to_time.to_i
                               }
                              })
            else
                render(json: { error: @user.errors.full_messages }, status: 422)
            end
        end

        private def user_params
            params.permit(:email, :password, :role)
        end

        def generate_refresh_token
            loop do
              token = SecureRandom.hex(32)
              break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
            end
        end 
    end
end