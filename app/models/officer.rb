class Officer < ApplicationRecord
    has_many :messages, as: :message, dependent: :destroy
    has_and_belongs_to_many :complaints, join_table: :officers_complaints
    has_many :request_messages, -> { where(message_type: 'User') }, through: :complaints, source: :messages, dependent: :destroy

    def is_head_for_complaint(complaint_id)
        OfficersComplaint.find_by(complaint_id: complaint_id)&.IsHead
    end
end