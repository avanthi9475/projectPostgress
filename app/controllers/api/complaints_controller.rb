class Api::ComplaintsController < Api::ApiController 
  # GET /complaints
  def index 
    if current_user.present? 
      if current_user.role=='officer' && current_userlogin.present?  && current_userlogin.role=='DSP' 
        @complaints = Complaint.all
      else
        @complaints = current_userlogin.complaints
      end
      if @complaints && @complaints.size>=1
        render json: @complaints, status: 200
      else
        render json: {error: 'No complaints found'}, status: 204
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # GET /complaints/1 
  def show
    if current_user.present? && current_userlogin.present?
      @complaints = current_userlogin.complaints
      @complaint = Complaint.find_by(id: params[:id].to_i)
      if @complaint.present?
        if ((@complaints.size>=1 && @complaints.include?(@complaint)) || (current_user.role=='officer' && current_userlogin.role=='DSP'))
          render json: @complaint, status: 200
        else
          render json: {error: 'You are not authorized to view others complaints'}, status: 403
        end
      else
        render json: {error: 'Complaint Not Found'}, status: 204
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  def mycomplaints
    if current_user.present?
      if current_userlogin.present?
        @complaints = current_userlogin.complaints
        if @complaints && @complaints.size >= 1
            render json: @complaints, status: 200
        else
          render json: {notice: 'You have not made any complaints'}, status: 204
        end
      else
        render json: {error: 'User Not Found'}, status: 204
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  def handledByOfficer
    if current_user.present? && current_userlogin.present?
      @complaints = current_userlogin.complaints
      @complaint = Complaint.find_by(id: params[:id].to_i)
      if @complaint.present? 
        if ((current_user.role=='officer' && current_userlogin.role=='DSP') || (@complaints.size>=1 && @complaints.include?(@complaint)))
          @officers = @complaint.officers 
          if @officers && @officers.size>=1
            render json: @officers, status: 200
          else
            render json: {error: 'This complaint is not yet assigned to any officer'}, status: 204
          end
        else
          render json: {error: 'You are not authorized to view others complaints'}, status: 403
        end
      else
        render json: {error: 'Complaint Not Found'}, status: 204
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # POST /complaints 
  def create
    if current_user.present? 
      @complaint = Complaint.new(complaint_params)
      if current_user.role=='user'
        @complaint.user_id = current_userlogin.id
        @officer = Officer.find_by(role: 'DSP')
        if @complaint.save &&  current_userlogin && current_userlogin.update(noOfComplaintsMade: current_userlogin.noOfComplaintsMade + 1 )
          @officers_complaints = OfficersComplaint.new(officer_id: @officer.id, complaint_id: @complaint.id, IsHead: "Yes")
          if @officers_complaints.save
            render json: @complaint, status: 200
          else
            render json: {error: @officers_complaints.errors.full_messages}, status: 403
          end
        else
          render json: {error: @complaint.errors.full_messages}, status: 403
        end
      else
        @officer = Officer.find_by(role: 'DSP')
        @user = User.find_by(id: params[:complaint][:user_id])
        if @user && @user.update(noOfComplaintsMade: @user.noOfComplaintsMade + 1 ) && @complaint.save 
          @officers_complaints = OfficersComplaint.new(officer_id: @officer.id, complaint_id: @complaint.id, IsHead: "Yes")
          if @officers_complaints.save
            render json: @complaint, status: 200
          else
            render json: {error: @officers_complaints.errors.full_messages}, status: 403
          end
        else
          render json: {error: 'User Not Found'}, status: 204
        end
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # PATCH/PUT /complaints/1 
  def update
    if current_user.present? && current_userlogin.present?
      @complaints = current_userlogin.complaints
      @complaint = Complaint.find_by(id: params[:id].to_i)
      if @complaint.present? 
        if ((current_user.role=='officer' && current_userlogin.role=='DSP') || (@complaints.size>=1 && @complaints.include?(@complaint)))
          if params[:complaint][:user_id]!=nil 
            render json: {error: 'ID cannot be updated'}, status: 403
          else
            if params[:complaint][:statement]!=nil 
              @complaint.statement = params[:complaint][:statement]
            end
            if params[:complaint][:location]!=nil 
              @complaint.location =params[:complaint][:location]
            end
            if params[:complaint][:dateTime]!=nil 
              @complaint.dateTime = params[:complaint][:dateTime]
            end
            if @complaint.save
              render json: @complaint, status: 200
            else
              render json: {error: @complaint.errors.full_messages}, status: 403
            end
          end
        else
          render json: {error: 'You are not authorized to edit others complaints'}, status: 403
        end
      else
        render json: {error: 'Complaint Not Found'}, status: 204
      end
    else
      render json: {error: 'Restricted Access'}, status: 403
    end
  end

  # DELETE /complaints/1 
  def destroy
    if current_user.present? && current_userlogin.present?
      @complaints = current_userlogin.complaints
      @complaint = Complaint.find_by(id: params[:id].to_i)
      if @complaint.present? 
        if ((current_user.role=='officer' && current_userlogin.role=='DSP') || (@complaints.size>=1 && @complaints.include?(@complaint)))
          if @complaint.destroy
            render json: { message: "Complaint deleted successfully" } , status: 200
          else
            render json: {error: @complaint.errors.full_messages} , status: 404
          end
        else
          render json: {error: 'You are not authorized to delete others complaints'}, status: 404
        end
      else
        render json: {error: 'Complaint does not exist'}, status: 403
      end
    else
      render json: {error: 'Restricted Access'}, status: 404
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def complaint_params
      params.require(:complaint).permit(:user_id, :statement, :location, :dateTime)
    end
end
