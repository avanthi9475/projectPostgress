ActiveAdmin.register CrimeFir do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :complaint_id, :under_section, :crime_category, :dateTime_of_crime
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :complaint_id, :under_section, :crime_category, :dateTime_of_crime]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  index do
    column :user
    column :complaint do |crime_fir|
      link_to crime_fir.complaint_id, admin_complaint_path(crime_fir.complaint_id)
    end
    column :under_section
    column :crime_category
    column :created_at
    actions
  end

  filter :complaint, as: :select, collection: Complaint.all.map{|c| [c.id, c.id]}
  filter :user
  filter :under_section
  filter :crime_category
  filter :dateTime_of_crime
  filter :created_at

  scope :all
  scope :registered
  scope :inprogress
  scope :resolved

end
