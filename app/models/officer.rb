class Officer < ApplicationRecord
    has_many :complaints, dependent: :destroy
    has_many :messages, as: :message
    has_many :officer_messages, source: :messages, through: :complaints, class_name: 'Message'
end
