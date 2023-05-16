class Complaint < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id'
    belongs_to :officer, foreign_key: 'officer_id'
    has_many :messages, dependent: :destroy
    has_one :status, as: :statusable, dependent: :destroy
end 
