class Api::MessagesController <  Api::ApiController 

  # GET /messages
  def index
    if current_user.present?
      if current_userlogin.present? && current_user.role=='officer' && current_userlogin.role=='DSP'
        @messages = Message.all
      elsif current_userlogin.present?
        @messages = current_userlogin.messages
      end
      if @messages && @messages.size>=1
        render json: @messages, status: 200
      else
        render json: {error: 'You have not received any messages'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}
    end
  end

  # GET /messages/1
  def show
    if current_user.present? 
      @message = Message.find_by(id: params[:id])
      if current_user.role=='officer' && current_userlogin.role=='DSP'
        if @message
          render json: @message, status: 200
        else
          render json: {error: 'Message Not Found'}, status: 404
        end
      else
        if @message && current_userlogin.present?
          @messages = current_userlogin.messages
          if @messages.size>=1 && @messages.include?(@message)
            render json: @message, status: 200
          else
            render json: {error: "You don't have access to view other's messages"}, status: 404
          end
        else
          render json: {error: 'Message Not Found'}, status: 404
        end
      end
    else
      render json: {error: 'Restricted Access'}
    end
  end

  # POST /messages
  def create
    if current_user.present? && current_userlogin.present?
      @message = current_userlogin.messages.new(message_params)
      @complaint = Complaint.find_by(id: params[:message][:complaint_id])
      @complaints = current_userlogin.complaints
      if @message.present? && @complaints.include?(@complaint)
        if(current_user.role=='user')
          @status = Status.new({status: "Pending"})
          @message.status = @status
          if @message.save && (current_user.role=='user' || @status.save)
            render json: @message, status: 200
          else
            render json: {error: @message.errors.full_messages}, status: 404
          end
        else 
          @msg = Message.find_by(id: params[:message][:parent_id])
          if @msg.present?
            @status = @msg.status
            @status.status = "Responded"
            if @message.save && (current_user.role=='user' || @status.save)
              render json: @message, status: 200
            else
              render json: {error: @message.errors.full_messages}, status: 404
            end
          else
            render json: {error: 'This complaint does not have any request messages{Please provide the request message id properly}'}, status: 404
          end
        end
      else
        render json: {error: 'Complaint Does not exist'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 404
    end
  end

  # PATCH/PUT /messages/1
  def update
    if current_user.present? && current_userlogin.present?
      @messages = current_userlogin.messages
      @message = Message.find_by(id: params[:id].to_i)
      if @message.present? 
        if (@messages.size>=1 && @messages.include?(@message)) || (current_user.role=='officer' && current_userlogin.role=='DSP')
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
          render json: {error: "You don't have access to edit others messages"}, status: 404
        end
      else
        render json: {error: 'Message not found'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 404
    end
  end

  # DELETE /messages/1
  def destroy
    if current_user.present? && current_userlogin.present? && current_user.role=='officer'
      @messages = current_userlogin.messages
      @message = Message.find_by(id: params[:id].to_i)
      if @message.present? 
        if (@messages.size>=1 && @messages.include?(@message)) || (current_user.role=='officer' && current_userlogin.role=='DSP')
          if @message.destroy
            render json: {message: 'Message was deleted successfully'}, status: 200
          else
            render json: {error: @message.errors.full_messages}, status: 404
          end
        else
          render json: {error: "You don't have access to delete others messages"}, status: 404
        end
      else
        render json: {error: 'Message not found'}, status: 404
      end
    else
      render json: {error: 'Restricted Access'}, status: 404
    end    
  end

  private
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:complaint_id, :statement, :dateTime, :parent_id)
    end
end
