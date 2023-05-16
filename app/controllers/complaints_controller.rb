class ComplaintsController < ApplicationController
  before_action :set_complaint, only: %i[ show edit update destroy ]

  # GET /complaints
  def index
    @complaints = Complaint.all
  end

  # GET /complaints/1 
  def show
  end

  def mycomplaints
    @user = User.find_by(id: Current.user.id)
    @complaints = @user.complaints
  end

  # GET /complaints/new
  def new
    @complaint = Complaint.new
  end

  # GET /complaints/1/edit
  def edit
  end

  # POST /complaints 
  def create
    @complaint = Complaint.new(complaint_params)
    @status = Status.new({status: "Inprogress"})
    @complaint.status = @status
    
    @user = User.find_by(id: params[:complaint][:user_id])

    respond_to do |format|
      if @complaint.save && @status.save && @user.update(noOfComplaintsMade: @user.noOfComplaintsMade + 1 )
        format.html { redirect_to complaint_url(@complaint), notice: "Complaint was successfully created." }
        format.json { render :show, status: :created, location: @complaint }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /complaints/1 
  def update
    respond_to do |format|
      @status = @complaint.status
      if @complaint.update(complaint_params) && @status.update(status: params[:complaint][:status])
        format.html { redirect_to complaint_url(@complaint), notice: "Complaint was successfully updated." }
        format.json { render :show, status: :ok, location: @complaint }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
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
      @complaint = Complaint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def complaint_params
      params.require(:complaint).permit(:user_id, :officer_id, :statement, :location, :dateTime)
    end

end
