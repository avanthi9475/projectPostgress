class Api::ComplaintsController < Api::ApiController 
  # GET /complaints
  def index
    @complaints = Complaint.all
    if @complaints
      render json: @complaints, status: 200
    else
      render json: {error: 'Complaint Not Found'}, status: 404
    end
  end

  # GET /complaints/1 
  def show
    @complaint = Complaint.find_by(id: params[:id].to_i)
    if @complaint 
      render json: @complaint, status: 200
    else
      render json: {error: 'Complaint Not Found'}, status: 404
    end
  end

  def mycomplaints
    @user = User.find_by(id: params[:user_id])
    if @user.present?
      @complaints = @user.complaints
      if @complaints && @complaints.size > 1
          render json: @complaints, status: 200
      else
        render json: {notice: 'You have not made any complaints'}, status: 404
      end
    else
      render json: {error: 'User Not Found'}, status: 404
    end
  end

  def handledByOfficer
    @complaint = Complaint.find_by(id: params[:id])
    if @complaint
      @officers = @complaint.officers 
      if @officers
        render json: @officers, status: 200
      else
        render json: {error: 'This complaint is not yet assigned to any officer'}, status: 404
      end
    else
      render json: {error: 'Complaint Not Found'}, status: 404
    end
  end

  # POST /complaints 
  def create
    @complaint = Complaint.new(complaint_params)
    @officer = Officer.find_by(role: 'DSP')
    @user = User.find_by(id: params[:complaint][:user_id])
    if @user && @complaint.save && @user.update(noOfComplaintsMade: @user.noOfComplaintsMade + 1 )
        @officers_complaints = OfficersComplaint.new(officer_id: @officer.id, complaint_id: @complaint.id, IsHead: "Yes")
        if @officers_complaints.save
          render json: @complaint, status: 200
        else
          render json: {error: @officers_complaints.errors.full_messages}, status: 404
        end
    else
      render json: {error: 'User Not Found'}, status: 404
    end
  end

  # PATCH/PUT /complaints/1 
  def update
    @complaint = Complaint.find_by(id: params[:id].to_i)
    if @complaint.present?
      @status = @complaint.status
      if params[:status] != nil
        @status.status = params[:status]
      end
      if @status.save
        render json: 'Updation Successfull', status: 200
      else
        render json: {error: @status.errors.full_messages}, status: 404
      end
    end
  end

  # DELETE /complaints/1 
  def destroy
    @complaint = Complaint.find_by(id: params[:id])
    if @complaint
      if @complaint.destroy
        render json: { message: "Complaint deleted successfully" } , status: 200
      else
        render json: {error: @complaint.errors.full_messages} , status: 404

      end
    else
      render json: {error: 'Complaint does not exist'}, status: 403
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def complaint_params
      params.require(:complaint).permit(:user_id, :statement, :location, :dateTime)
    end
end
