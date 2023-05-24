class CrimeFir < ApplicationRecord
    belongs_to :complaint, foreign_key: 'complaint_id'
    has_one :status, as: :statusable, dependent: :destroy

    validates :user_id, presence: true
    validates :complaint_id, presence: true, uniqueness: true
    validates :under_section, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :crime_category, presence: true, format: { with: /\A[a-zA-Z]+\z/ }
    
end
