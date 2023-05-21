ActiveAdmin.register Officer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :name, :age, :location, :role
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :name, :age, :location, :role]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column :email
    column :name
    column :age
    column :location
    column :role
    actions
  end 
  
  filter :complaints_id_eq, as: :select, collection: Complaint.all.map{|c| [c.id]}, label: "Complaint ID"
  filter :role, as: :select
  filter :email
  filter :name
  filter :age
  filter :location
  filter :created_at

end
