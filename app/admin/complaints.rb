ActiveAdmin.register Complaint do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :statement, :location, :dateTime
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :statement, :location, :dateTime]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column :user
    column :statement
    column :location
    actions
  end
  
  filter :user
  filter :officers
  filter :statement
  filter :location
  filter :created_at

  scope :all
  scope :registered
  scope :inprogress
  scope :resolved
  
end
