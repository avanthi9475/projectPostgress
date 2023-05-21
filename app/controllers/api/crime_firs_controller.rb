class Api::CrimeFirsController < Api::ApiController 

  def index
    @crime_firs = CrimeFir.all
    if @crime_firs && @crime_firs.size>1
      render json: @crime_firs, status: 200
    else
      render json: {error: 'You have not created any FIR'}, status: 404
    end
  end 

  def show
    @crime_fir = CrimeFir.find_by(id: params[:id])
    if @crime_fir
      render json: @crime_fir, status: 200
    else
      render json: {error: 'FIR Not Found'}, status: 404
    end
  end

  def create
    @user = User.find_by(id: params[:crime_fir][:user_id])
    if @user.present?
      @complaint = Complaint.find_by(id: params[:crime_fir][:complaint_id])
      if @complaint.present?
        @crime_fir = CrimeFir.new(crime_fir_params)
        @status = Status.new({status: "Inprogress"})
        @crime_fir.status = @status
        if @crime_fir.save &&  @status.save 
          render json: @crime_fir, status: 200
        else
          render json: {error: @crime_fir.errors.full_messages}, status: 404
        end
      else
        render json: {error: 'Complaint not found'}, status: 404
      end
    else
      render json: {error: 'User not found'}, status: 404
    end
  end 

  def update
    @crime_fir = CrimeFir.find_by(id: params[:id].to_i)
    if @crime_fir.present?
      @status = @crime_fir.status
      if params[:crime_fir][:complaint_id]!=nil || params[:crime_fir][:user_id]!=nil
        render json: {error: 'ID cannot be updated'}, status: 404
      else
        if params[:crime_fir][:under_section]!=nil 
          @crime_fir.under_section =params[:crime_fir][:under_section]
        end
        if params[:crime_fir][:status]!=nil 
          @status.status = params[:crime_fir][:status]
        end
        if params[:crime_fir][:crime_category]!=nil 
          @crime_fir.crime_category = params[:crime_fir][:crime_category]
        end
        if params[:crime_fir][:dateTime_of_crime]!=nil 
          @crime_fir.dateTime_of_crime = params[:crime_fir][:dateTime_of_crime]
        end
        if @crime_fir.save && @status.save
          render json: @crime_fir, status: 200
        else
          render json: {error: @crime_fir.errors.full_messages}, status: 404
        end
      end
    else
      render json: {error: 'FIR does not exist'}, status: 404
    end
  end

  def destroy
    @crime_fir = CrimeFir.find_by(id: params[:id].to_i)
    if @crime_fir.present?
      if @crime_fir.destroy
        render json: {message: 'FIR was deleted successfully'}, status: 200
      else
        render json: {error: @crime_fir.errors.full_messages}, status: 404
      end
    else
      render json: {error: 'FIR not found'}, status: 404
    end
  end

  private

    def crime_fir_params
      params.require(:crime_fir).permit(:user_id, :complaint_id, :under_section, :crime_category, :dateTime_of_crime)
    end

end
