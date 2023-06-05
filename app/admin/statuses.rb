ActiveAdmin.register Status do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :statusable_id, :statusable_type, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:statusable_id, :statusable_type, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column :status_type do |status|
      if status.statusable_type=='Message' && (status.status=='Sent' || status.status=='Received')
        'Response Message Status'
      elsif status.statusable_type=='Message' && (status.status=='Pending' || status.status=='Responded')
        'Request Message Status'
      elsif status.statusable_type=='CrimeFir'
        'Complaint Status'
      end
    end
    column :status
    column :created_at
    actions
  end

  config.remove_action_item (:new)

  scope :all
  scope :complaint_statuses
  scope :request_message_statuses
  scope :response_messages_statuses
  
end
