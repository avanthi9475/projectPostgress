class Complaint < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id'
    has_many :messages, dependent: :destroy
    has_one :crime_fir, dependent: :destroy
    has_and_belongs_to_many :officers, join_table: :officers_complaints
    has_one :status, through: :crime_fir, dependent: :destroy
    has_one :lead_officer, class_name: 'Officer', foreign_key: 'id', primary_key: 'leadOfficerID', dependent: :destroy
    
    # scope :inprogress, -> {Complaint.joins(:status).where(statuses: {status: 'Inprogress'})}
    # scope :resolved, -> {Complaint.joins(:status).where(statuses: {status: 'Resolved'})}
end 
