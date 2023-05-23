class Status < ApplicationRecord
    belongs_to :statusable, polymorphic: true

    scope :complaint_statuses, ->{Status.where(statuses: {statusable_type: 'Complaint'})}
    scope :request_message_statuses, ->{Status.where(statuses: {statusable_type: 'Message'}).where(statuses: {status: ['Pending','Responded']})}
    scope :response_messages_statuses, ->{Status.where(statuses: {statusable_type: 'Message'}).where(statuses: {status: ['Sent','Received']})}
end