class CrimeFirsController < ApplicationController
  before_action :authenticate_user_login!
  before_action :set_complaint, only: %i[ show edit update destroy ]

  def index
    if current_user_login.present? && current_user_login.role=='officer'
      if Current.user.role=='DSP'
        @crime_firs = CrimeFir.all
      else
        @crime_firs = Current.user.crime_firs
      end
    else
      redirect_user("Unauthorized Access")
    end
  end 

  def show
    if current_user_login.present? && current_user_login.role=='officer'
      @crime_fir = CrimeFir.find_by(id: params[:id])
      @crime_firs = Current.user.crime_firs
      if @crime_fir
        unless ((@crime_firs.size>=1 && @crime_firs.include?(@crime_fir)) || (@current_user_login.role && Current.user.role=='DSP'))
          redirect_user("Unauthorized Access")
        end
      else
        redirect_user("Invalid FIR Id")
      end
    else
      redirect_user("Unauthorized Access")
    end
  end

  def new 
    if current_user_login.present? && current_user_login.role=='officer'
      @crime_fir = CrimeFir.new
    else
      redirect_user("Unauthorized Access")
    end
  end

  def edit
    if current_user_login.present? && current_user_login.role=='officer'
      @crime_fir = CrimeFir.find_by(id: params[:id])
      @crime_firs = Current.user.crime_firs
      if @crime_fir
        unless ((@crime_firs.size>=1 && @crime_firs.include?(@crime_fir)) || (@current_user_login.role && Current.user.role=='DSP'))
          redirect_user("Unauthorized Access")
        end
      else
        redirect_user("Invalid FIR Id")
      end 
    else
      redirect_user("Unauthorized Access")
    end
  end

  def create
    if current_user_login.present? && current_user_login.role=='officer'
      @crime_fir = CrimeFir.new(crime_fir_params)

      respond_to do |format|
        if @crime_fir.save
          format.html { redirect_to crime_fir_url(@crime_fir), notice: "FIR Record was successfully created." }
          format.json { render :show, status: :created, location: @crime_fir }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @complaint.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_user("Unauthorized Access")
    end
  end 

  def update
    if current_user_login.present? && current_user_login.role=='officer'
      @crime_fir = CrimeFir.find_by(id: params[:id])
      @crime_firs = Current.user.crime_firs
      if ((@crime_firs.size>=1 && @crime_firs.include?(@crime_fir)) || (@current_user_login.role && Current.user.role=='DSP'))
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
      else
        redirect_user("unauthorized Access")
      end
    else
      redirect_user("unauthorized Access")
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
    @crime_fir = CrimeFir.find_by(id: params[:id])
    unless @crime_fir 
      redirect_user("Invalid FIR Id")
    end
  end

    def crime_fir_params
      params.require(:crime_fir).permit(:user_id, :complaint_id, :under_section, :crime_category, :dateTime_of_crime)
    end

end
