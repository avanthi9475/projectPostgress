class Complaint < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id'
    has_many :messages, dependent: :destroy
    has_one :crime_fir, dependent: :destroy
    has_and_belongs_to_many :officers, join_table: :officers_complaints, dependent: :destroy
    has_one :status, through: :crime_fir, dependent: :destroy
    has_one :lead_officer, class_name: 'Officer', foreign_key: 'id', primary_key: 'leadOfficerID', dependent: :destroy

    validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :statement, presence: true, length: {minimum: 15}
    validates :location, presence: true, format: { with: /\A[a-zA-Z]+\z/ }
    validates :dateTime, presence: true

    scope :registered, ->{Complaint.joins(:crime_fir).joins(:status).where(statuses:{status: 'Registered'})}
    scope :inprogress, ->{Complaint.joins(:crime_fir).joins(:status).where(statuses:{status: 'Inprogress'})}
    scope :resolved, ->{Complaint.joins(:crime_fir).joins(:status).where(statuses:{status: 'Resolved'})}
    
end 
