class OfficersController < ApplicationController
  before_action :set_officer, only: %i[ show edit update destroy ]

  # GET /officers
  def index
    @officers = Officer.all
  end

  # GET /officers/1 
  def show
  end

  # GET /officers/new
  def new
    @officer = Officer.new
  end

  # GET /officers/1/edit
  def edit
  end

  def viewRequestMsg
    @messages =  Current.user.officer_messages.where(message_type: 'User')
    @messages = @messages.select { |msg| msg.status.status == "Pending" }
  end

  # POST /officers 
  def create
    @officer = Officer.new(officer_params)
    @login = UserLogin.new(email: params[:officer][:email], password: params[:officer][:password], role: 'officer')
    respond_to do |format|
      if @officer.save && @login.save
        format.html { redirect_to officer_url(@officer), notice: "Officer was successfully created." }
        format.json { render :show, status: :created, location: @officer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /officers/1
  def update
    respond_to do |format|
      if @officer.update(officer_params)
        format.html { redirect_to officer_url(@officer), notice: "Officer was successfully updated." }
        format.json { render :show, status: :ok, location: @officer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /officers/1 
  def destroy
    @officer.destroy

    respond_to do |format|
      format.html { redirect_to officers_url, notice: "Officer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_officer
      @officer = Officer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def officer_params
      params.require(:officer).permit(:email, :name, :age, :location, :role)
    end
end
