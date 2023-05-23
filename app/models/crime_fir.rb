class CrimeFir < ApplicationRecord
    belongs_to :complaint, foreign_key: 'complaint_id'
    has_one :status, as: :statusable, dependent: :destroy
end
