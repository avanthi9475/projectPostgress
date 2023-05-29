class OfficersComplaint < ApplicationRecord
    belongs_to :complaint, foreign_key: 'complaint_id'
    belongs_to :officer, foreign_key: 'officer_id'
    enum IsHead: {Yes:'Yes', No: 'No'}

    validates :IsHead, presence: true
end