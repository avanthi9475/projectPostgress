class Api::OfficersController < Api::ApiController 

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
      render json: {error: 'Restricted Access'}
    end
  end

  # GET /officers/1 
  def show
    if current_user.present? && current_user.role=='officer' && ((current_userlogin.role=='DSP') || (current_userlogin.present? && current_userlogin.id==params[:id].to_i))
      @officer = Officer.find_by(id: params[:id].to_i)
      if @officer 
        render json: @officer, status: 200
      else
        render json: {error: 'Officer Not Found'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}
    end
  end

  def viewRequestMsg
    if current_user.present? && current_user.role=='officer' && current_userlogin.present?
      @messages =  current_userlogin.request_messages 
      @messages = @messages.select { |msg| msg.status.status == "Pending" }                                                                                                        
      if @messages && @messages.size>=1
        render json: @messages, status: 200
      else
        render json: 'You Have Not Received Any Request Messages', status: 404
      end
    else
      render json: {error: 'Restricted Access'}
    end
  end

  # POST /officers 
  def create
    if current_user.present? && current_user.role=='officer' && current_userlogin.present? && current_userlogin.role=='DSP'
      @officer = Officer.new(officer_params)      
      @login = UserLogin.new(email: params[:email], password: params[:password], role: 'officer')
      if @login.save && @officer.save
        render json: @officer, status: 200
      else
        render json: {error: @login.errors.full_messages}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}
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
            render json: {error: @login.errors.full_messages}, status: 404
          end
        else
          render json: {error: 'Officer does not exist'}, status: 403
        end
      else
        render json: {error: 'Email ID cannot be changed'}, status: 403
      end
    else
      render json: {error: 'Restricted Access'}
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
          render json: {error: @officer.errors.full_messages} , status: 404

        end
      else
        render json: {error: 'Officer does not exist'}, status: 403
      end
    else
      render json: {error: 'Restricted Access'}
    end
  end


  private
  
    def officer_params
      params.require(:officer).permit(:email, :name, :age, :location, :role)
    end
end
