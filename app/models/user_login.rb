class UserLogin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  def self.authenticate(email,password)
    user = UserLogin.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :role, presence: true

  enum role: { admin: 'admin', user: 'user', officer: 'officer' }

  scope :number_of_users, ->{UserLogin.where(role: 'user')}
  scope :number_of_officers, ->{UserLogin.where(role: 'officer')}

  def isUser?
    if role=='user'
      return true
    else
      return false
    end
  end

  def isOfficer?
    if role=='officer'
      return true
    else
      return false
    end
  end
  
end
