class Complaint < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id'
    belongs_to :officer, foreign_key: 'officer_id'
end
