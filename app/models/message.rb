class Message < ApplicationRecord
    belongs_to :message, polymorphic: true
    belongs_to :complaint, foreign_key: 'complaint_id'
    has_one :status, as: :statusable, dependent: :destroy
end
