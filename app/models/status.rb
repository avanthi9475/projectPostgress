class Status < ApplicationRecord
    belongs_to :statusable, polymorphic: true

    enum status: {Inprogress:'Inprogress', Responded: 'Responded', Pending: 'Pending', Resolved: 'Resolved', Sent: 'Sent', Received: 'Received'}

    validates :status, presence: true
    
    scope :complaint_statuses, ->{Status.where(statuses: {statusable_type: 'CrimeFir'})}
    scope :request_message_statuses, ->{Status.where(statuses: {statusable_type: 'Message'}).where(statuses: {status: ['Pending','Responded']})}
    scope :response_messages_statuses, ->{Status.where(statuses: {statusable_type: 'Message'}).where(statuses: {status: ['Sent','Received']})}
end