class UserLogin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: { admin: 'admin', user: 'user', officer: 'officer' }

  scope :number_of_users, ->{UserLogin.where(role: 'user')}
  scope :number_of_officers, ->{UserLogin.where(role: 'officer')}
  
end
