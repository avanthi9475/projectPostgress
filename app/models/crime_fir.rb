class CrimeFir < ApplicationRecord
    belongs_to :complaint, foreign_key: 'complaint_id'
    belongs_to :user, foreign_key: 'user_id'
    has_one :status, as: :statusable, dependent: :destroy

    after_create :create_status

    validates :user_id, presence: true
    validates :complaint_id, presence: true, uniqueness: true
    validates :under_section, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :crime_category, presence: true, format: { with: /\A[a-zA-Z]+\z/ }, length: {maximum: 10}
    validates :dateTime_of_crime, presence: true

    def create_status
        @status = Status.new({status: "Inprogress"})
        self.status = @status
        @status.save
    end
    
    scope :registered, ->{CrimeFir.joins(:status).where(statuses:{status: 'Registered'})}
    scope :inprogress, ->{CrimeFir.joins(:status).where(statuses:{status: 'Inprogress'})}
    scope :resolved, ->{CrimeFir.joins(:status).where(statuses:{status: 'Resolved'})}
    
end
