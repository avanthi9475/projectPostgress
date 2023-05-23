class Api::UsersController < Api::ApiController   

  def index
    if current_user.present? && current_user.role=='officer' && current_userlogin.present? && current_userlogin.role=='DSP'
      @users = User.all
      if @users && @users.size>=1
        render json: @users, status: 200
      else
        render json: {error: 'User Not Found'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # GET /users/1 
  def show
    if current_user.present? && current_userlogin.present? && ((current_user.role=='officer' && current_userlogin.role=='DSP') || (current_user.role=='user' && current_userlogin.id==params[:id].to_i))
      @user = User.find_by(id: params[:id].to_i)
      if @user 
        render json: @user, status: 200
      else
        render json: {error: 'User Not Found'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  def viewResponse
    if current_user.present? && current_userlogin.present? && current_user.role=='user'
      @messages = current_userlogin.response_messages
      if @messages && @messages.size>=1
        render json: @messages, status: 200
      else
        render json: 'You Have Not Received Any Respond Messages', status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # POST /users
  def create
    if current_user.present? && current_userlogin.present? &&  current_user.role=="officer" && current_userlogin.role=='DSP'
      if params[:role]=='user'
        @user = User.new(user_params)
        @login = UserLogin.new(email: params[:email], role: params[:role], password: params[:password])
        if @login.save && @user.save
          render json: @user, status: 200
        else
          render json: {error: @login.errors.full_messages}, status: 404
        end
      else
        render json: {error: 'Role can only be user'}, status: 403
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  def update
    if current_user.present? && current_userlogin.present? && ((current_user.role=='officer') || (current_user.role=='user' && current_userlogin.id==params[:id]))
      @user = User.find_by(id: params[:id])
      if(params[:user][:email]==nil)
        if @user.present?
          if params[:user][:name]!=nil 
            @user.name = params[:user][:name]
          end
          if params[:user][:age]!=nil 
            @user.age =params[:user][:age]
          end
          if params[:user][:location]!=nil 
            @user.location = params[:user][:location]
          end
          if @user.save
            render json: @user, status: 200
          else
            render json: {error: @login.errors.full_messages}, status: 404
          end
        else
          render json: {error: 'User does not exist'}, status: 403
        end
      else
        render json: {error: 'Email ID cannot be changed'}, status: 403
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # DELETE /users/1
  def destroy
    if current_user.present? && current_user.role=='officer' && current_userlogin.present? && current_userlogin.role=='DSP'
      @user = User.find_by(id: params[:id])
      if @user
        if @user.destroy
          render json: { message: "User deleted successfully" } , status: 200
        else
          render json: {error: @user.errors.full_messages} , status: 404
        end
      else
        render json: {error: 'User does not exist'}, status: 403
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :age, :location, :noOfComplaintsMade)
  end

end
