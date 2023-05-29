class MessagesController < ApplicationController
  before_action :authenticate_user_login!
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages
  def index
    if Current.user && current_user_login.role=='officer' && Current.user.role=='DSP'
      @messages = Message.all
    elsif Current.user
      @messages = Current.user.messages
    end
  end

  # GET /messages/1
  def show
    @message = Message.find_by(id: params[:id])
    @messages = Current.user.messages
    unless ((current_user_login.role=='officer' && Current.user.role=='DSP') || (@messages.size>=1 && @messages.include?(@message)))
      redirect_user("Unauthorized Access")
    end 
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find_by(id: params[:id])
    @messages = Current.user.messages
    unless ((current_user_login.role=='officer' && Current.user.role=='DSP') || (@messages.size>=1 && @messages.include?(@message)))
      redirect_user("Unauthorized Access")
    end
  end

  def respondMsg
    @message = Message.find_by(id: params[:id])
    if @message
      if current_user_login.role=='officer'
        @message = Message.new
      else
        redirect_user("Unauthorized Access")
      end
    else
      redirect_user("Invalid Message ID")
    end
  end

  # POST /messages
  def create
    @message = Current.user.messages.new(message_params)
    if(current_user_login.role=='user')
      @status = Status.new({status: "Pending"})
      @message.status = @status
    else
      @msg = Message.find_by(id: params[:message][:parent_id])
      @status = @msg.status
      @status.status = "Responded"
    end
    # @message = Message.new(@msg.attributes)
    respond_to do |format|
      if @message.save && (current_user_login.role=='user' || @status.save)
        format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  def update
    @message = Message.find_by(id: params[:id])
    @messages = Current.user.messages
    if ((current_user_login.role=='officer' && Current.user.role=='DSP') || (@messages.size>=1 && @messages.include?(@message)))
      respond_to do |format|
        if @message.update(message_params)
          format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
          format.json { render :show, status: :ok, location: @message }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_user("Unauthorized Access")
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
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find_by(id: params[:id])
      unless @message 
        redirect_user("Invalid Message ID")
      end
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:complaint_id, :statement, :dateTime, :parent_id)
    end
end
