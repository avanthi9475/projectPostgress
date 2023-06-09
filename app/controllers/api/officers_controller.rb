class Api::OfficersController < Api::ApiController 
  before_action :set_officer, only: %i[ show edit update destroy ]

  # GET /officers
  def index
    if current_user.present? && current_user.role=='officer' && current_userlogin.present? && current_userlogin.role=='DSP'
      @officers = Officer.all
      if @officers && @officers.size>=1
        render json: @officers, status: 200
      else
        render json: {error: 'Officer Not Found'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # GET /officers/1 
  def show
    if current_user.present? && current_user.role=='officer' && ((current_userlogin.role=='DSP') || (current_userlogin.present? && current_userlogin.id==params[:id]))
      @officer = Officer.find_by(id: params[:id].to_i)
      if @officer 
        render json: @officer, status: 200
      else
        render json: {error: 'Officer Not Found'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  def viewRequestMsg
    if current_user.present? && current_user.role=='officer' && current_userlogin.present?
      @messages =  current_userlogin.request_messages
      @messages = @messages.select { |msg| msg.status.status == "Pending" || msg.status.status == "Sent"}                                                                                                        
      if @messages && @messages.size>=1
        render json: @messages, status: 200
      else
        render json: {error: 'You Have Not Received Any Request Messages'}, status: 204
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # POST /officers 
  def create
    if current_user.present? && current_user.role=='officer' && current_userlogin.present? && current_userlogin.role=='DSP'
      @officer = Officer.new(officer_params)      
      @login = UserLogin.new(email: params[:email], password: params[:password], role: 'officer',  confirmed_at:Time.current)
      if @login.save && @officer.save
        render json: @officer, status: 200
      else
        render json: {error: @login.errors.full_messages}, status: 400
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # PATCH/PUT /officers/1
  def update
    if current_user.present? && current_user.role=='officer' && ((current_userlogin.role=='DSP') || (current_userlogin.present? && current_userlogin.id==params[:id].to_i))
      @officer = Officer.find_by(id: params[:id].to_i)
      if(params[:officer][:email]==nil)
        if @officer.present?
          if params[:officer][:name]!=nil 
            @officer.name = params[:officer][:name]
          end
          if params[:officer][:age]!=nil 
            @officer.age =params[:officer][:age]
          end
          if params[:officer][:location]!=nil 
            @officer.location = params[:officer][:location]
          end
          if params[:officer][:role]!=nil 
            @officer.role = params[:officer][:role]
          end
          if @officer.save
            render json: @officer, status: 200
          else
            render json: {error: @login.errors.full_messages}, status: 204
          end
        else
          render json: {error: 'Officer does not exist'}, status: 404
        end
      else
        render json: {error: 'Email ID cannot be changed'}, status: 400
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # DELETE /officers/1 
  def destroy
    if current_user.present? && current_user.role=='officer' && current_userlogin.present? && current_userlogin.role=='DSP'
      @officer = Officer.find_by(id: params[:id])
      if @officer
        if @officer.destroy
          render json: { message: "Officer deleted successfully" } , status: 200
        else
          render json: {error: @officer.errors.full_messages} , status: 204

        end
      else
        render json: {error: 'Officer does not exist'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end


  private

  def set_officer
    @officer = Officer.find_by(id: params[:id])
    unless @officer 
      render json: {error: 'Officer does not exist'}, status: 404
    end
  end
  
    def officer_params
      params.require(:officer).permit(:email, :name, :age, :location, :role)
    end
end
