class User < ApplicationRecord
    has_many :complaints, dependent: :destroy
    has_many :messages, as: :message,   dependent: :destroy
    has_many :response_messages, -> { where(message_type: 'Officer') },  source: :messages, through: :complaints, class_name: 'Message', dependent: :destroy
    has_many :crime_firs, through: :complaints

    validates :name, presence: true, format: { with: /\A[a-zA-Z]+\z/ }
    validates :age, presence: true, numericality: { only_integer: true, greater_than: 18 }
    validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :location, presence: true, format: { with: /\A[a-zA-Z]+\z/ } 
    validates :noOfComplaintsMade, numericality: {only_integer: true, greater_than: -1} 

    scope :users_having_less_than_5_complaints, ->{User.where('"noOfComplaintsMade" < ?', 5).where('"noOfComplaintsMade" > ?', 0)}
    scope :users_having_more_than_5_complaints, ->{User.where('"noOfComplaintsMade" > ?', 5)}
    scope :users_having_more_than_10_complaints, ->{User.where('"noOfComplaintsMade" > ?', 10)}
    scope :users_who_have_made_not_made_any_complaints, ->{User.where(noOfComplaintsMade: 0)}

end
