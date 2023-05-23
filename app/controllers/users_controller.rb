class UsersController < ApplicationController
  before_action :authenticate_user_login!
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users
  def index
    if current_user_login.role=='officer' && Current.user.role=='DSP'
      @users = User.all
    elsif current_user_login.role=='officer'
      @users = Current.user.users
    else
      redirect_user("Unauthorized Access")
    end
  end

  # GET /users/1 
  def show
    @user = User.find_by(id: params[:id])
    if current_user_login.role=='officer'
      @users = Current.user.users
      unless @users.include?(@user) || Current.user.role=='DSP'
        redirect_user("Unauthorized Access")
      end
    else
      unless @user.id == Current.user.id
        redirect_user("Unauthorized Access")
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by(id: params[:id])
    if current_user_login.role=='officer'
      @users = Current.user.users
      unless @users.include?(@user) || Current.user.role=='DSP'
        redirect_user("Unauthorized Access")
      end
    else
      unless @user.id == Current.user.id
        redirect_user("Unauthorized Access")
      end
    end
  end

  def viewResponse
    if current_user_login.role=='user'
      @messages = Current.user.response_messages
    else
      redirect_user("Unauthorized Access")
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @login = UserLogin.new(login_params)

    respond_to do |format|
      if @user.save && @login.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(id: params[:id])
      unless @user 
        redirect_user("Invalid User ID")
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :age, :location, :noOfComplaintsMade)
    end

    def login_params
      params.require(:user).permit(:email, :password, :role)
    end
end
