class User < ApplicationRecord
    has_many :complaints, dependent: :destroy
    has_many :messages, as: :message
    has_many :user_messages, source: :messages, through: :complaints, class_name: 'Message'
end
