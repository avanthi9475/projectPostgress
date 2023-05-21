ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :name, :age, :location, :noOfComplaintsMade
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :name, :age, :location, :noOfComplaintsMade]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column :email
    column :name
    column :age
    column :location
    column :noOfComplaintsMade
    column :created_at
    actions
  end

  filter :complaints, as: :select, collection: Complaint.all.map{|c| [c.id, c.id]}
  filter :email
  filter :name
  filter :age
  filter :location
  filter :noOfComplaintsMade
  filter :created_at

  scope :all
  scope :users_having_less_than_5_complaints
  scope :users_having_more_than_5_complaints
  scope :users_having_more_than_10_complaints
  scope :users_who_have_made_not_made_any_complaints
end
