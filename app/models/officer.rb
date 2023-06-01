class Officer < ApplicationRecord
    has_many :messages, as: :message, dependent: :destroy
    has_and_belongs_to_many :complaints, join_table: :officers_complaints, dependent: :destroy
    has_many :request_messages, -> { where(message_type: 'User') }, through: :complaints, source: :messages, dependent: :destroy
    has_many :crime_firs, through: :complaints
    has_many :users, through: :complaints

    validates :name, presence: true, format: { with: /\A[a-zA-Z]+\z/ }
    validates :age, presence: true, numericality: { only_integer: true, greater_than: 18 }
    validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :location, presence: true, format: { with: /\A[a-zA-Z]+\z/ }  
    validates :role, presence: true, format: { with: /\A[a-zA-Z]+\z/ }

    enum role: {DSP: 'DSP', Inspector: 'Inspector', SubInspector: 'SubInspector'}

    def is_head_for_complaint(complaint_id, officer_id)
        OfficersComplaint.find_by(complaint_id: complaint_id, officer_id: officer_id)&.IsHead
    end
end