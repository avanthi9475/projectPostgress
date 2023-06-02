class MessagesController < ApplicationController
  before_action :authenticate_user_login!
  before_action :set_message, only: %i[ show edit update destroy respondMsg]
  before_action :check_for_messages

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
    if(current_user_login.role=='officer')
      @msg = Message.find_by(id: params[:message][:parent_id])
      @msg.status.update(status: 'Responded')
    end
    respond_to do |format|
      if @message.save
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
    if current_user_login.role=='user'
      @messages = Current.user.response_messages
    else
      @messages = Current.user.request_messages
    end
    @message = Message.find_by(id: params[:id].to_i)
    if (@messages.size>=1 && @messages.include?(@message)) || (current_user_login.role=='officer' && Current.user.role=='DSP')
      @message.destroy
      if current_user_login.role=='user'
        respond_to do |format|
          format.html { redirect_to viewResponse_path, notice: "Message was successfully destroyed." }
          format.json { head :no_content}
        end
      else
        respond_to do |format|
          format.html { redirect_to viewRequestMsg_path, notice: "Message was successfully destroyed." }
          format.json { head :no_content}
        end
      end
    else
      redirect_user("Restricted Access")
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
