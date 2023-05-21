class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages
  def index
    @messages = Message.all
    if @messages
      render json: @messages, status: 200
    else
      render json: {error: 'Message Not Found'}, status: 404
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
    @user = User.find_by(id: params[:id])
    @complaint = Complaint.find_by(id: params[:message][:complaint_id])
    if @user.present? && @complaint.present?
      @message = @user.messages.new(message_params)
      if(@user.role=='user')
        @status = Status.new({status: "Pending"})
        @message.status = @status
      else
        @msg = Message.find_by(id: params[:message][:parent_id])
        @status = @msg.status
        @status.status = "Responded"
      end
      if @message.save && (current_user_login.role=='user' || @status.save)
        render json: @message, status: 200
      else
        render json: {error: @message.errors.full_messages}, status: 404
      end
    else
      render json: {error: 'User Not Found'}, status: 404
    end
  end

  # PATCH/PUT /messages/1
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  def destroy

    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:complaint_id, :statement, :dateTime, :parent_id)
    end
end
