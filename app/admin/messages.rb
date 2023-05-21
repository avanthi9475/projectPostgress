ActiveAdmin.register Message do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :message_id, :message_type, :complaint_id, :statement, :dateTime, :parent_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:message_id, :message_type, :complaint_id, :statement, :dateTime, :parent_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column :message_type do |message|
      if message.message_type=='User'
        'Request Message'
      elsif message.message_type=='Officer'
        'Response Message'
      end
    end
    column :complaint do |message|
      link_to message.complaint_id, admin_complaint_path(message.complaint_id)
    end
    column :statement
    column :status do |message|
      message.status.status
    end
    actions
  end

  filter :message_type
  filter :complaint, as: :select, collection: Complaint.all.map{|c| [c.id, c.id]}
  filter :statement
  filter :created_at

  scope :all
  scope :request_messages
  scope :response_messages
  scope :pending_request_messages
  scope :responded_request_messages
  scope :sent_response_messages
  scope :received_response_messages

  config.remove_action_item (:new)
  
end
