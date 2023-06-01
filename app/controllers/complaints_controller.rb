class ComplaintsController < ApplicationController
  before_action :set_complaint, only: %i[ show edit update destroy ]
  before_action :authenticate_user_login!
  before_action :check_for_messages

  # GET /complaints
  def index
    if current_user_login.role=='officer' && Current.user.role=='DSP'
      @complaints = Complaint.all
    elsif current_user_login.role=='officer'
      @complaints = Current.user.complaints
    elsif current_user_login.role=='user'
      redirect_user("Unauthorized Access")
    end
  end

  # GET /complaints/1 
  def show
    @complaint = Complaint.find_by(id: params[:id])
    @complaints = Current.user.complaints
    unless @complaints && @complaints.include?(@complaint) || (current_user_login.role=='officer' && Current.user.role=='DSP')
      redirect_user("Unauthorized Access")
    end
  end

  def mycomplaints
    if current_user_login.role=='user'
      @user = User.find_by(id: Current.user.id)
      @complaints = @user.complaints
    else
      redirect_user("Unauthorized Access")
    end
  end

  def assign_new_officer
    @officers_complaints = OfficersComplaint.new(officer_id: params[:assign_to_officer], complaint_id: params[:id], IsHead: "No")
    if @officers_complaints.save
      flash[:notice] = 'Officer Assigned Successfully'
      redirect_to "/handledByOfficer/#{params[:id]}"
    else
      flash[:alert] = 'Some unknown error occured'
      redirect_to "/handledByOfficer/#{params[:id]}"
    end
  end

  def remove_officer
    @complaint = OfficersComplaint.find_by(officer_id: params[:officer_id], complaint_id: params[:complaint_id])
    if @complaint && @complaint.IsHead == 'Yes'
      flash[:alert] = 'Lead Officer cannot be removed. please assign some other officer as lead and then try!!'
      redirect_to "/handledByOfficer/#{params[:complaint_id]}"
    elsif @complaint.destroy
      flash[:notice] = 'Officer Removed Successfully'
      redirect_to "/handledByOfficer/#{params[:complaint_id]}"
    else
      flash[:alert] = @complaint.error.full_messages
      redirect_to "/handledByOfficer/#{params[:complaint_id]}"
    end 
  end

  def make_head
    @officer1 = OfficersComplaint.find_by(complaint_id: params[:complaint_id], IsHead:'Yes')
    @officer2 = OfficersComplaint.find_by(officer_id: params[:officer_id], complaint_id: params[:complaint_id])

    if @officer1.update(IsHead: 'No') && @officer2.update(IsHead: 'Yes')
      flash[:notice] = 'Lead Changed Successfully'
      redirect_to "/handledByOfficer/#{params[:complaint_id]}"
    else
      flash[:alert] = @officer2.error.full_messages
      redirect_to "/handledByOfficer/#{params[:complaint_id]}"
    end 
  end

  def handledByOfficer
    @complaint = Complaint.find_by(id: params[:id])
    @complaints = Current.user.complaints
    if @complaint
      unless ((@complaints && @complaints.include?(@complaint)) || (@current_user_login.role=='officer' && Current.user.role=='DSP'))
        redirect_user("Unauthorized Access")
      else
        @officers = @complaint.officers.order(:created_at)
      end
    else
      redirect_user("Invalid ID")
    end
  end

  # GET /complaints/new
  def new
    @complaint = Complaint.new
  end

  # GET /complaints/1/edit
  def edit
    @complaint = Complaint.find_by(id: params[:id])
    @complaints = Current.user.complaints
    unless ((@complaints && @complaints.include?(@complaint)) || (@current_user_login.role=='officer' && Current.user.role=='DSP'))
      redirect_user("Unauthorized Access")
    end
  end
 
  # POST /complaints 
  def create
    @complaint = Complaint.new(complaint_params)
    @officer = Officer.find_by(role: 'DSP')
    @user = User.find_by(id: params[:complaint][:user_id])  
    @user.update(noOfComplaintsMade: @user.noOfComplaintsMade+1)
    respond_to do |format|
      if @complaint.save 
        @officers_complaints = OfficersComplaint.new(officer_id: @officer.id, complaint_id: @complaint.id, IsHead: "Yes")
        if @officers_complaints.save
          format.html { redirect_to complaint_url(@complaint), notice: "Complaint was successfully created." }
          format.json { render :show, status: :created, location: @complaint }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @complaint.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /complaints/1 
  def update
    @complaint = Complaint.find_by(id: params[:id])
    @complaints = Current.user.complaints
    if @complaints && @complaints.include?(@complaint) || (current_user_login.role=='officer' && Current.user.role=='DSP')
      respond_to do |format|
        if @complaint.update(complaint_params)
          format.html { redirect_to complaint_url(@complaint), notice: "Complaint was successfully updated." }
          format.json { render :show, status: :ok, location: @complaint }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @complaint.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_user("Unauthorized Access")
    end
  end

  # DELETE /complaints/1 
  def destroy
    @complaint.destroy

    respond_to do |format|
      format.html { redirect_to complaints_url, notice: "Complaint was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_complaint
      @complaint = Complaint.find_by(id: params[:id])
      unless @complaint 
        redirect_user("Invalid Complaint ID")
      end
    end

    # Only allow a list of trusted parameters through.
    def complaint_params
      params.require(:complaint).permit(:user_id, :statement, :location, :dateTime)
    end


end
