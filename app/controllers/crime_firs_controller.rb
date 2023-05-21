class CrimeFirsController < ApplicationController

  before_action :set_complaint, only: %i[ show edit update destroy ]

  def index
    @crime_firs = CrimeFir.all
  end 

  def show
  end

  def new 
    @crime_fir = CrimeFir.new
  end

  def edit
  end

  def create
    @crime_fir = CrimeFir.new(crime_fir_params)
    @status = Status.new({status: "Inprogress"})
    @crime_fir.status = @status

    respond_to do |format|
      if @crime_fir.save &&  @status.save 
        format.html { redirect_to crime_fir_url(@crime_fir), notice: "FIR Record was successfully created." }
        format.json { render :show, status: :created, location: @crime_fir }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end 

  def update
    respond_to do |format|
      @status = @crime_fir.status
      @status.status = params[:crime_fir][:status]
      if @crime_fir.update(crime_fir_params) && @status.save
        format.html { redirect_to crime_fir_url(@crime_fir), notice: "FIR Record was successfully updated." }
        format.json { render :show, status: :ok, location: @crime_fir }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @crime_fir.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @crime_fir.destroy

    respond_to do |format|
      format.html { redirect_to crime_fir_url, notice: "FIR Record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_complaint
    @crime_fir = CrimeFir.find(params[:id])
  end

    def crime_fir_params
      params.require(:crime_fir).permit(:user_id, :complaint_id, :under_section, :crime_category, :dateTime_of_crime)
    end

end
