class Message < ApplicationRecord
    belongs_to :message, polymorphic: true
    belongs_to :complaint, foreign_key: 'complaint_id'
    has_one :status, as: :statusable, dependent: :destroy
    belongs_to :request, class_name: 'Message', optional: true
    has_one :response, class_name: 'Message', foreign_key: 'parent_id', dependent: :destroy
    
    validates :complaint_id, presence: true
    validates :statement, presence: true

    scope :request_messages, ->{Message.where(message_type: 'User')}
    scope :response_messages, ->{Message.where(message_type: 'Officer')}
    scope :pending_request_messages, ->{Message.where(message_type: 'User').joins(:status).where(statuses:{status: 'Pending'})}
    scope :responded_request_messages, ->{Message.where(message_type: 'User').joins(:status).where(statuses:{status: 'Responded'})}
    scope :sent_response_messages, ->{Message.where(message_type: 'Officer').joins(:status).where(statuses:{status: 'Sent'})}
    scope :received_response_messages, ->{Message.where(message_type: 'Officer').joins(:status).where(statuses:{status: 'Received'})}
end
