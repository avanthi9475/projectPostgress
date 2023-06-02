class OfficersController < ApplicationController
  before_action :authenticate_user_login!
  before_action :set_officer, only: %i[ show edit update destroy ]
  before_action :check_for_messages


  # GET /officers
  def index
    if current_user_login.role=='officer' && Current.user.role=='DSP'
      @officers = Officer.all.where.not("role = ?", 'DSP')
    else
      redirect_user("Unauthorized Access")
    end
  end

  # GET /officers/1 
  def show
    unless current_user_login.role=='officer' && ((Current.user.role=='DSP') || (Current.user.id==params[:id].to_i))
      redirect_user("Unauthorized Access")
    end
  end

  # GET /officers/new
  def new
    unless current_user_login.role=='officer' && Current.user.role=='DSP'
      redirect_user("Unauthorized Access")
    else
      @officer = Officer.new
    end
  end

  # GET /officers/1/edit  
  def edit
    unless current_user_login.role=='officer' && ((Current.user.role=='DSP') || (Current.user.id==params[:id].to_i))
      redirect_user("Unauthorized Access")
    end
  end

  def viewRequestMsg
    if current_user_login.role=='officer'
      @messages =  Current.user.request_messages                                                                                                         
      @messages = @messages.select { |msg| msg.status.status == "Pending" }
    else
      redirect_user("Unauthorized Access")
    end
  end

  # POST /officers 
  def create
    if current_user_login.role=='officer' && Current.user.role=='DSP'
      @officer = Officer.new(officer_params)
      @login = UserLogin.new(email: params[:officer][:email], password: params[:officer][:password], role: 'officer', confirmed_at:Time.current)
      respond_to do |format|
        if @officer.save && @login.save
          format.html { redirect_to officer_url(@officer), notice: "Officer was successfully created." }
          format.json { render :show, status: :created, location: @officer }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @officer.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_user("Unauthorized Access")
    end
  end

  # PATCH/PUT /officers/1
  def update
    if current_user_login.role=='officer' && ((Current.user.role=='DSP') || (Current.user.id==params[:id].to_i))
      respond_to do |format|
        if @officer.update(officer_params)
          format.html { redirect_to officer_url(@officer), notice: "Officer was successfully updated." }
          format.json { render :show, status: :ok, location: @officer }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @officer.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_user("Unauthorized Access")
    end
  end

  # DELETE /officers/1 
  def destroy
    if current_user_login.role=='officer' && Current.user.role=='DSP'
      @officer.destroy

      respond_to do |format|
        format.html { redirect_to officers_url, notice: "Officer was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_user("Restricted Access")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_officer
      @officer = Officer.find_by(id: params[:id])
      unless @officer 
        redirect_user("Invalid Officer ID")
      end
    end

    # Only allow a list of trusted parameters through.
    def officer_params
      params.require(:officer).permit(:email, :name, :age, :location, :role)
    end
end
