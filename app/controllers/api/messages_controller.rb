class Api::MessagesController <  Api::ApiController 

  # GET /messages
  def index
    @messages = Message.all
    if @messages && @messages.size>1
      render json: @messages, status: 200
    else
      render json: {error: 'You have not received and messages'}, status: 404
    end
  end

  # GET /messages/1
  def show
    @message = Message.find_by(id: params[:id])
    if @message
      render json: @message, status: 200
    else
      render json: {error: 'Message Not Found'}, status: 404
    end
  end

  # POST /messages
  def create
    @user = User.find_by(id: params[:user_id])
    if @user.present?
      @login = UserLogin.find_by(email: @user.email)
      if @login.present?
        @message = @user.messages.new(message_params)
        if(@login.role=='user')
          @status = Status.new({status: "Pending"})
          @message.status = @status
        else
          @msg = Message.find_by(id: params[:message][:parent_id])
          @status = @msg.status
          @status.status = "Responded"
        end
        if @message.save && (@login.role=='user' || @status.save)
          render json: @message, status: 200
        else
          render json: {error: @message.errors.full_messages}, status: 404
        end
      else
        render json: {error: 'User not found'}, status: 404
      end
    else
      render json: {error: 'User not found'}, status: 404
    end
  end

  # PATCH/PUT /messages/1
  def update
    @message = Message.find_by(id: params[:id].to_i)
    if @message.present?
      if params[:message][:complaint_id]!=nil 
        render json: {error: 'Complaint ID cannot be updated'}, status: 404
      else
        if params[:message][:statement]!=nil 
          @message.statement =params[:message][:statement]
        end
        if params[:message][:dateTime]!=nil 
          @message.dateTime = params[:message][:dateTime]
        end
        if @message.save
          render json: @message, status: 200
        else
          render json: {error: @message.errors.full_messages}, status: 404
        end
      end
    else
      render json: {error: 'Message not found'}, status: 404
    end
  end

  # DELETE /messages/1
  def destroy
    @message = Message.find_by(id: params[:id].to_i)
    if @message.present?
      if @message.destroy
        render json: {message: 'Message was deleted successfully'}, status: 200
      else
        render json: {error: @message.errors.full_messages}, status: 404
      end
    else
      render json: {error: 'Message not found'}, status: 404
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:complaint_id, :statement, :dateTime, :parent_id)
    end
end
